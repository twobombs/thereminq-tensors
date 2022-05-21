#
# factor the primes from the modulus of the generated key in /root/.ssh
#
fact=$(</root/.ssh/modulus2.dec)
sed -i "s/toFactor=.*/toFactor=$fact/g" /pyqrack-jupyter/shor.py
#
for j in {1...100}
    do
    ipython3 /pyqrack-jupyter/shor.py > factoring
    cat factoring | grep 'Factors found'
    echo 'Prime #1:   ' $prime 'Prime #2:   ' $prime2 'Multiplied: ' $fact
    echo ' '
done