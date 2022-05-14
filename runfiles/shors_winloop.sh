for i in {1..55108}
    do
	for j in {1..10}
	do
	prime=$(matho-primes -c 1 -u $i)
	echo $(($prime * $prime)) > i2
	i2=$(<i2)
	prime2=$(matho-primes -c 1 -u $i2)
	echo $(($prime * $prime2)) > fact
	fact=$(<fact)
	sed -i "s/toFactor=.*/toFactor=$fact/g" /pyqrack-jupyter/shor.py
	ipython3 /pyqrack-jupyter/shor.py > factoring
	cat factoring | grep 'Factors found'
	cat factoring | grep Failed
	echo 'Prime #1:   ' $prime 'Prime #2:   ' $prime2 'Multiplied: ' $fact
	echo ' '
    done
done
