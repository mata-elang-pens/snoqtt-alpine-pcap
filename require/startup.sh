#!/bin/sh

# Setup snort.conf
sed -i \
-e 's@^ipvar HOME_NET.*@ipvar HOME_NET '"${PROTECTED_SUBNET}"'@' \
-e 's@^ipvar EXTERNAL_NET.*@ipvar EXTERNAL_NET '"${EXTERNAL_SUBNET}"'@' \
-e 's@^var RULE_PATH.*@var RULE_PATH /etc/snort/rules@' \
-e 's@^var SO_RULE_PATH.*@var SO_RULE_PATH /etc/snort/so_rules@' \
-e 's@^var PREPROC_RULE_PATH.*@var PREPROCRULE_PATH /etc/snort/preproc_rules@' \
-e 's@^var WHITE_LIST_PATH.*@var WHITE_LIST_PATH /etc/snort/rules/iplists@' \
-e 's@^var BLACK_LIST_PATH.*@var BLACK_LIST_PATH /etc/snort/rules/iplists@' \
-e 's@^\(include $.*\)@# \1@' \
-e 's@\# include \$RULE\_PATH\/local\.rules@include \$RULE\_PATH\/local\.rules@' \
-e '/include \$RULE\_PATH\/local\.rules/a include \$RULE\_PATH\/snort\.rules' \
/etc/snort/snort.conf

# Setup pulledpork
sed -i 's@.oinkcode.@'"${OINKCODE}"'@' /etc/snort/pulledpork.conf &&\
/usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l &&\
snort -T -c /etc/snort/snort.conf &&\
sed -i '/import alert/c\import snortunsock.alert as alert' /usr/lib/python3.7/site-packages/snortunsock/snort_listener.py

# Start service
/usr/bin/supervisord -c /root/libs/super_snort.conf