CXX = g++
CXXFLAGS = -std=c++11 -Wall -I lib/include -I src/IPCServer/include -I src/IPCClient/include
LDFLAGS = -lpthread

LIB_DIR = lib
SRC_DIR = src
BUILD_DIR = build

REACTOR_SRC = $(LIB_DIR)/src/reactor/reactor.cc
REACTOR_OBJ = $(BUILD_DIR)/reactor.o
REACTOR_LIB = $(BUILD_DIR)/libreactor.a

IPC_SERVER_SRC = $(SRC_DIR)/IPCServer/src/IPCServer.cc
IPC_SERVER_OBJ = $(BUILD_DIR)/ipcserver.o
IPC_SERVER_LIB = $(BUILD_DIR)/libipcserver.a

IPC_CLIENT_SRC = $(SRC_DIR)/IPCClient/src/IPCClient.cc
IPC_CLIENT_OBJ = $(BUILD_DIR)/ipcclient.o
IPC_CLIENT_LIB = $(BUILD_DIR)/libipcclient.a

MAIN_SRC = $(SRC_DIR)/main.cc
MAIN_OBJ = $(BUILD_DIR)/main.o
MAIN_BIN = $(BUILD_DIR)/reactor-main

ALL_LIBS = $(REACTOR_LIB) $(IPC_SERVER_LIB) $(IPC_CLIENT_LIB)
ALL_OBJS = $(REACTOR_OBJ) $(IPC_SERVER_OBJ) $(IPC_CLIENT_OBJ) $(MAIN_OBJ)

.PHONY: all clean

all: $(MAIN_BIN)

$(REACTOR_LIB): $(REACTOR_OBJ)
	ar rcs $@ $^

$(IPC_SERVER_LIB): $(IPC_SERVER_OBJ)
	ar rcs $@ $^

$(IPC_CLIENT_LIB): $(IPC_CLIENT_OBJ)
	ar rcs $@ $^

$(REACTOR_OBJ): $(REACTOR_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(IPC_SERVER_OBJ): $(IPC_SERVER_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(IPC_CLIENT_OBJ): $(IPC_CLIENT_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(MAIN_OBJ): $(MAIN_SRC)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(MAIN_BIN): $(ALL_OBJS) $(ALL_LIBS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

clean:
	rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/reactor.o: $(REACTOR_SRC) | $(BUILD_DIR)
$(BUILD_DIR)/ipcserver.o: $(IPC_SERVER_SRC) | $(BUILD_DIR)
$(BUILD_DIR)/ipcclient.o: $(IPC_CLIENT_SRC) | $(BUILD_DIR)
$(BUILD_DIR)/main.o: $(MAIN_SRC) | $(BUILD_DIR)
