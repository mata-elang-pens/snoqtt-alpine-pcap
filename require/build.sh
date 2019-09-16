#!/bin/sh

# Symlink libtirpc
ln -s /usr/include/tirpc/rpc /usr/include/rpc && ln -s /usr/include/tirpc/netconfig.h /usr/include/netconfig.h

# File requirement yang dibutuhkan package python untuk menjalankan snort
pip3 install --no-cache-dir --upgrade pip setuptools wheel && hash -r pip && \
pip3 install --no-cache-dir -r /root/requirements.txt

# Membuat direktori untuk menyimpan berkas sumber
mkdir -p /root/snort_src && mkdir -p /root/daq_src && mkdir -p /root/pulledpork_src

# Unduh snort
wget https://www.snort.org/downloads/snort/snort-2.9.14.1.tar.gz -O /root/snort.tar.gz &&\
tar -xvzf /root/snort.tar.gz --strip-components=1 -C /root/snort_src &&\
rm /root/snort.tar.gz

# Unduh Daq
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz -O /root/daq.tar.gz &&\
tar -xvzf /root/daq.tar.gz --strip-components=1 -C /root/daq_src && \
rm /root/daq.tar.gz

# Unduh Pulledpork
wget https://github.com/mata-elang-pens/pulledpork/archive/v0.7.3.tar.gz -O /root/pulledpork.tar.gz &&\
tar -xvzf /root/pulledpork.tar.gz --strip-components=1 -C /root/pulledpork_src &&\
rm /root/pulledpork.tar.gz

# Compile source code dari daq
cd /root/daq_src && \
echo "#include <unistd.h>" > /usr/include/sys/unistd.h && \
./configure && \
make && \
make install

# Compile source code dari snort
cd /root/snort_src && \
./configure --enable-sourcefire --disable-open-appid && \
make && \
make install && \
ln -s /usr/local/bin/snort /usr/sbin/snort

# Membuat user dan group snort
addgroup -S snort && adduser -S snort -g snort

# Membuat dan mengatur direktori untuk snort
mkdir /etc/snort && \
mkdir /etc/snort/rules && \
mkdir /etc/snort/rules/iplists && \
mkdir /etc/snort/preproc_rules && \
mkdir /etc/snort/so_rules && \
mkdir /var/log/snort && \
mkdir /var/log/snort/archived_logs && \
mkdir /usr/local/lib/snort_dynamicrules && \
mkdir /tmp/snort && \
touch /etc/snort/rules/iplists/white_list.rules /etc/snort/rules/iplists/black_list.rules /etc/snort/rules/local.rules /etc/snort/sid-msg.map && \
chmod -R 5775 /etc/snort && \
chmod -R 5775 /var/log/snort && \
chmod -R 5775 /var/log/snort/archived_logs && \
chmod -R 5775 /usr/local/lib/snort_dynamicrules && \
chown -R snort:snort /etc/snort && \
chown -R snort:snort /var/log/snort && \
chown -R snort:snort /usr/local/lib/snort_dynamicrules && \
cp /root/snort_src/etc/*.conf* /etc/snort && \
cp /root/snort_src/etc/*.map /etc/snort && \
cp /root/snort_src/etc/*.dtd /etc/snort && \
cp /root/snort_src/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/* /usr/local/lib/snort_dynamicpreprocessor/

# Install Pulledpork
cp /root/pulledpork_src/pulledpork.pl /usr/local/bin && \
chmod +x /usr/local/bin/pulledpork.pl &&\
cp /root/pulledpork_src/etc/*.conf /etc/snort &&\
cp /root/pulledpork.conf /etc/snort

# Cleaning up
rm -rf /root/snort_src /root/daq_src /root/pulledpork_src /root/requirements.txt /root/build.sh