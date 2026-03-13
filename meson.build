project('reactor-pattern', 'cpp',
    version: '1.0.0',
    default_options: ['cpp_std=c++11']
)

inc_reactor = include_directories('lib/include')
inc_ipcserver = include_directories('src/IPCServer/include')
inc_ipcclient = include_directories('src/IPCClient/include')

reactor_lib = static_library('reactor',
    'lib/src/reactor/reactor.cc',
    include_directories: inc_reactor
)

ipcserver_lib = static_library('ipcserver',
    'src/IPCServer/src/IPCServer.cc',
    include_directories: [inc_reactor, inc_ipcserver],
    link_with: reactor_lib
)

ipcclient_lib = static_library('ipcclient',
    'src/IPCClient/src/IPCClient.cc',
    include_directories: [inc_reactor, inc_ipcclient],
    link_with: reactor_lib
)

executable('reactor-main',
    'src/main.cc',
    include_directories: [inc_reactor, inc_ipcserver, inc_ipcclient],
    link_with: [ipcserver_lib, ipcclient_lib],
    link_args: '-lpthread'
)
