cmake_minimum_required(VERSION 3.0)
project(Calculator)

# 查找Flex和Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# 生成解析器和词法分析器
BISON_TARGET(Parser clac.y ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/y.tab.h
)
FLEX_TARGET(Scanner clac.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)
ADD_FLEX_BISON_DEPENDENCY(Scanner Parser)

# 添加可执行文件
add_executable(calculator ${BISON_Parser_OUTPUTS} ${FLEX_Scanner_OUTPUTS})

# 设置包含目录
target_include_directories(calculator PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# 链接必要的库
target_link_libraries(calculator ${FLEX_LIBRARIES})