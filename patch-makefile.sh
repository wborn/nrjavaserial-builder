#!/bin/bash -x
set -euo pipefail

file="$1"

# Add missing OpenJDK 8 includes
sed -i 's#JDKINCLUDE=-I/usr/lib/jvm/java-7-openjdk-amd64/include/ -I/usr/lib/jvm/java-7-openjdk-i386/include/#JDKINCLUDE=-I/usr/lib/jvm/java-8-openjdk-amd64/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/linux/#g' "$file"

# Disable using lock files
sed -i 's#-DLIBLOCKDEV#-DDISABLE_LOCKFILES#g' "$file"
sed -i 's# -llockdev##g' "$file"

# Fix file names of ARMv7 libraries
sed -i 's#resources/native/linux/ARM/libNRJavaSerial.so#resources/native/linux/ARM/libNRJavaSerialv7.so#g' "$file"
sed -i 's#resources/native/linux/ARM/libNRJavaSerial_HF.so#resources/native/linux/ARM/libNRJavaSerialv7_HF.so#g' "$file"

# Add missing ARMv8 libraries
sed -i 's#.PHONY: arm arm7 arm7HF arm6 arm6HF arm5#.PHONY: arm arm8 arm8HF arm7 arm7HF arm6 arm6HF arm5#g' "$file"
sed -i 's#arm: arm7 arm7HF arm6 arm6HF arm5#arm: arm8 arm8HF arm7 arm7HF arm6 arm6HF arm5#g' "$file"

lines_before=$(($(grep -nr '# ARM v7' "$file" | head -n 1 | cut -d : -f 1) - 1))
head -n $lines_before "$file" > "/tmp/Makefile.ubuntu64.new"

cat >> "/tmp/Makefile.ubuntu64.new" <<'EOI'
# ARM v8

arm8: resources/native/linux/ARM/libNRJavaSerialv8.so

resources/native/linux/ARM/libNRJavaSerialv8.so: $(LINOBJ:%=build/arm8/%)
	@mkdir -p `dirname $@`
	$(LINKLINARM) -march=armv8-a -o $@ $^

build/arm8/%.o: src/%.c
	@mkdir -p `dirname $@`
	$(CCLINARM) -march=armv8-a -o $@ $<

# ARM v8 HF

arm8HF: resources/native/linux/ARM/libNRJavaSerialv8_HF.so

resources/native/linux/ARM/libNRJavaSerialv8_HF.so: $(LINOBJ:%=build/arm8HF/%)
	@mkdir -p `dirname $@`
	$(LINKLINARM_HF) -march=armv8-a -o $@ $^

build/arm8HF/%.o: src/%.c
	@mkdir -p `dirname $@`
	$(CCLINARM_HF) -march=armv8-a -o $@ $<

EOI


lines_after=$(($(cat "$file" | wc -l) - $lines_before + 1))
tail -n $lines_after "$file" >> "/tmp/Makefile.ubuntu64.new"

mv "/tmp/Makefile.ubuntu64.new" "$file"
