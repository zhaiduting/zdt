# 使用 Docker gcc 镜像编译 C 程序
# 用法示例: docker-gcc -static hello.c -o hello
alias docker-gcc='docker run --rm -v "$PWD":/src -w /src gcc:latest gcc'
