#!/bin/sh

cd work/kernel

# Change to the first directory ls finds, e.g. 'linux-4.15'.
cd $(ls -d *)

# Mostra o diretório atual para debug
echo "Building kernel in: $(pwd)"

# Limpeza
make mrproper

# Configuração
make defconfig

# Modificação do hostname
sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"minimal\"/" .config

# Compilação com verificação
if ! make bzImage -j $(nproc); then
    echo "Falha na compilação do kernel!"
    exit 1
fi

# Verifica se o bzImage foi criado
if [ ! -f arch/x86/boot/bzImage ]; then
    echo "ERRO: bzImage não foi gerado em $(pwd)/arch/x86/boot/"
    exit 1
else
    echo "bzImage gerado com sucesso em: $(pwd)/arch/x86/boot/bzImage"
    ls -lh arch/x86/boot/bzImage
fi

make headers_install

cd ../../..