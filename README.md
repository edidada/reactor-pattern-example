# reactor-pattern-example
.bazelrc
# `.bazelrc` 到底是干嘛的？（超直白解释）
一句话：
**它是 Bazel 的“默认配置文件”，用来给所有 Bazel 命令自动加参数、设置环境变量。**

你每次敲
```bash
bazel build
bazel test
bazel run
```
**Bazel 都会自动读取 .bazelrc，把里面的配置当成默认参数带上。**

---

## 1. 核心作用（你最需要知道的）
1. **统一团队构建配置**
   所有人用一样的编译参数，不会“我这能跑你那报错”

2. **不用每次敲长命令**
   比如你每次都要加：
   ```bash
   bazel build --jobs=8 --cxxopt=-std=c++17 //...
   ```
   写进 `.bazelrc` 后，直接：
   ```bash
   bazel build //...
   ```
   自动生效

3. **设置代理、缓存、平台、编译器**
   国内常用**加速配置**

4. **控制 Bazel 自身行为**
   内存、并发、输出路径、远程构建

---

## 2. 放在哪里？
直接放在**项目根目录**，和 `WORKSPACE` / `MODULE.bazel` 同级
```
你的项目/
├── .bazelrc        <-- 在这里
├── WORKSPACE
└── BUILD
```

---

## 3. 真实常用配置（直接复制可用）
```bash
# 并发数（根据你的CPU核心）
build --jobs=8

# C++ 编译标准
build --cxxopt=-std=c++17
build --cxxopt=-O2

# 开启颜色输出
build --color=yes

# 国内常用：关闭远程下载警告（不影响使用）
build --remote_download_warning_threshold=

# 内存限制
build --local_ram_resources=HOST_RAM*.5

# 测试并发
test --jobs=10
test --test_output=errors
```

---

## 4. 它和 .bashrc / .zshrc 区别？
- `.bashrc` / `.zshrc`：**系统终端**的配置
- **`.bazelrc`：只给 Bazel 用**的配置

---

## 5. 最简单总结
✅ **.bazelrc = Bazel 的默认启动参数配置**
✅ 写一次，**所有 bazel 命令自动生效**
✅ 团队统一构建环境必备


An implementation of a reactor pattern with the accompanying IPC server/client example use case.

<a href="https://scan.coverity.com/projects/reactor">
  <img alt="Coverity Scan Build Status"
       src="https://scan.coverity.com/projects/22593/badge.svg"/>
</a>


## PROBLEM

On UNIX based systems the *accept()* system call is used to accept a new connection on a listening socket. If no pending connections are present in the queue, and the socket is not marked as nonblocking, accept() blocks the caller until a connection is present. If the socket is marked nonblocking and no pending connections are present in the queue, accept() fails and returns some pre-defined errors. 

## REACTOR APPROACH

In order to circumvent blocking and avoid using polling, a reactor pattern can be utilized. This approach utilizes the reactor pattern introduced by Douglas Schmidt in his [Reactor paper](https://pdfs.semanticscholar.org/3d9f/fc7669ab488ea74841181e9b1be9d10d5cea.pdf?_ga=2.259182030.574174400.1563114230-2125772795.1563114230). The Reactor approach enables event-driven handling of incoming connections, which allows a server to do something else while waiting for a new connection. When a new connection request arrives, the reactor is the entity that will notify the server about the new incoming connection. In this way, invoking *accept()* by the server will not cause any blocking, because the waiting connection queue will not be empty. 

## IPC use case

This example comes with the full implementation of the reactor pattern in C++. It is runnable only on systems that come with a *select()* system call, which allows a program to monitor multiple file descriptors, waiting until one or more of the file descriptors become "ready" for some class of I/O operation. In this particular example, the IPCServer registers a read handler within the reactor on a UNIX domain socket (socket file). The same socket file is used by the IPCClient to establish an inter-process communication with the IPCServer. Whenever the IPCClient sends some data using this socket file, *select()* will mark this file descriptor as "ready" to read, and the reactor will dispatch this information to the appropriate registered handler (*handle_read* by IPCServer). In this way, the IPCServer can do something else and switch to processing of incoming connections only when it is informed by the reactor that they are present in the waiting queue. Hence, *accept()* will never  block.

The provided example is very basic and serves only for understanding the underlying mechanisms of a reactor pattern.

