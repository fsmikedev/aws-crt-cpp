## AWS Crt Cpp

C++ wrapper around the aws-c-* libraries. Provides Cross-Platform Transport Protocols and SSL/TLS implementations for C++.

### Currently Included:

* aws-c-common: Cross-platform primitives and data structures.
* aws-c-io: Cross-platform event-loops, non-blocking I/O, and TLS implementations.
* aws-c-mqtt: MQTT client.
* aws-c-auth: Auth signers such as Aws-auth sigv4
* aws-c-http: HTTP 1.1 client, and websockets (H2 coming soon)

More protocols and utilities are coming soon, so stay tuned.

## Building

The C99 libraries are already included for your convenience when you specify the `-DBUILD_DEPS=ON` CMake argument.

If you want to manage these dependencies manually (e.g. you're using them in other projects), simply specify
`-DCMAKE_INSTALL_PREFIX` to point to the directory where you have them installed.

## Dependencies?

### Windows and Apple
There are no non-OS dependencies that AWS does not own, maintain, and ship.

### Unix
The most likely answer is: none that you should care about.

We do depend on an openssl compatible libcrypto implementation being in your path if you are on a
unix system. Note: we do not actually use libssl. The most likely scenario is that libcrypto is already installed on your system. However, since
many linux distributions these days do not provide a 32-bit libcrypto package, if you're trying to perform a 32-bit build you will
likely need to build and install libcrypto from source.

## Common Usage

To do anything with IO, you'll need to create a few objects that will be used by the rest of the library.

For example:

````
    Aws::Crt::LoadErrorStrings();
````

Will load error strings for debugging purposes. Since the C libraries use error codes, this will allow you to print the corresponding
error string for each error code.

````
    Aws::Crt::ApiHandle apiHandle;
````
This performs one-time static initialization of the library. You'll need it to do anything, so don't forget to create one.

````
    Aws::Crt::Io::EventLoopGroup eventLoopGroup(<number of threads you want>);
````
To use any of our APIs that perform IO you'll need at least one event-loop. An event-loop group is a collection of event-loops that
protocol implementations will load balance across. If you won't have very many connections (say, more than 100 or so), then you
most likely only want 1 thread. In this case, you want to pass a single instance of this to every client or server implementation of a protocol
you use in your application. In some advanced use cases, you may want to reserve a thread for different types of IO tasks. In that case, you can have an
instance of this class for each reservation.

````
     Aws::Crt::Io::TlsContextOptions tlsCtxOptions =
        Aws::Crt::Io::TlsContextOptions::InitClientWithMtls(certificatePath.c_str(), keyPath.c_str());
    /*
     * If we have a custom CA, set that up here.
     */
    if (!caFile.empty())
    {
        tlsCtxOptions.OverrideDefaultTrustStore(nullptr, caFile.c_str());
    }

    uint16_t port = 8883;
    if (Io::TlsContextOptions::IsAlpnSupported())
    {
        /*
        * Use ALPN to negotiate the mqtt protocol on a normal
        * TLS port if possible.
        */
        tlsCtxOptions.SetAlpnList("x-amzn-mqtt-ca");
        port = 443;
    }

    Aws::Crt::Io::TlsContext tlsCtx(tlsCtxOptions, Io::TlsMode::CLIENT);
````

If you plan on using TLS, you will need a TlsContext. These are NOT CHEAP, so use as few as possible to perform your task.
If you're in client mode and not doing anything fancy (e.g. mutual TLS), then you can likely get away with using a single
instance for the entire application.

````
Aws::Crt::Io::ClientBootstrap bootstrap(eventLoopGroup);
````

Lastly, you will need a client or server bootstrap to use a client or server protocol implementation. Since everything is
non-blocking and event driven, this handles most of the "callback hell" inherent in the design. Assuming you aren't partitioning
threads for particular use-cases, you can have a single instance of this that you pass to multiple clients.

## License

This library is licensed under the Apache 2.0 License.
