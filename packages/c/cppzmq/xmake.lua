package("cppzmq")

    set_kind("library", {headeronly = true})
    set_homepage("http://www.zeromq.org/")
    set_description("Header-only C++ binding for libzmq")
    set_license("MIT")

    add_urls("https://github.com/zeromq/cppzmq/archive/refs/tags/$(version).tar.gz",
             "https://github.com/zeromq/cppzmq.git")
    add_versions("v4.8.1", "7a23639a45f3a0049e11a188e29aaedd10b2f4845f0000cf3e22d6774ebde0af")

    add_deps("cmake", "zeromq")
    on_install("windows", "macosx", "linux", function (package)
        import("package.tools.cmake").install(package, {"-DCPPZMQ_BUILD_TESTS=OFF"})
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets([[
            void test() {
                zmq::context_t ctx;
                zmq::socket_t sock(ctx, zmq::socket_type::push);
                sock.bind("inproc://test");
                sock.send(zmq::str_buffer("Hello, world"), zmq::send_flags::dontwait);
            }
        ]], {configs = {languages = "c++14"}, includes = "zmq.hpp"}))
    end)
