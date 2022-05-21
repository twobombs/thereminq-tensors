#!/bin/bash
#
# RSA key magick AYB64 - rsa keygen pub & private, convert to pem and extract Integers, Primes + vars in text and make it bot-readable
< /dev/zero ssh-keygen -q -b 1024 -t rsa -m PEM -N ""
cd /root/.ssh && openssl asn1parse -in id_rsa > id_rsa.vars
ssh-keygen -f id_rsa.pub -e -m pem > id_rsa_pub.pem && openssl asn1parse -in id_rsa_pub.pem > id_rsa_pub_pem.vars
openssl rsa -in id_rsa -noout -text > id_rsa_text.vars
sed 's/://g' id_rsa_text.vars | tr -d '\:\n' | sed "s/    //g" > id_rsa_text.parsable
# extract modulus and convert it to dec
cat id_rsa_text.parsable | sed -e 's/.*modulus\(.*\)publicExponent.*/\1/' | tr "a-z" "A-Z" > modulus.hex
modulus=$(< modulus.hex)  &&  echo "ibase=16; "$modulus |BC_LINE_LENGTH=0 bc > modulus.dec
# extract prime1 and convert it to dec
cat id_rsa_text.parsable | sed -e 's/.*prime1\(.*\)prime2.*/\1/' | tr "a-z" "A-Z" > prime1.hex
prime1=$(< prime1.hex)  &&  echo "ibase=16; "$prime1 |BC_LINE_LENGTH=0 bc > prime1.dec
# extract prime2 and convert it to dec
cat id_rsa_text.parsable | sed -e 's/.*prime2\(.*\)exponent.*/\1/' | tr "a-z" "A-Z" > prime2.hex
prime2=$(< prime2.hex)  &&  echo "ibase=16; "$prime2 |BC_LINE_LENGTH=0 bc > prime2.dec
# multiply two primes and compare
prime1dec=$(< prime1.dec) && prime2dec=$(< prime2.dec) && echo $prime1dec "*" $prime2dec | BC_LINE_LENGTH=0 bc > modulus2.dec
modulus=$(< modulus2.dec)  &&  echo "obase=16; ibase=10; "$modulus |BC_LINE_LENGTH=0 bc > modulus2.hex
echo "compare first 310 decimal numbers of modulus from prime1*prime2" && cat modulus.dec && tail -n 310 modulus2.dec 
#
# factor the primes from the primes and modulus of the generated key in /root/.ssh
#
for j in {1...100}
    do
    cat prime1.dec | ./qimcifa/qimcifa $1 > prime1.fact
    cat prime2.dec | ./qimcifa/qimcifa $1 > prime2.fact
    cat modulus2.dec | ./qimcifa/qimcifa $1 > modulus2.fact
    cat prime1.fact && cat prime2.fact && cat modulus2.fact
    echo ' '
done
