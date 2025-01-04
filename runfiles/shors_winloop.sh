for i in {65535..4294967295..255}
	do
		prime=$(matho-primes -c 1 -u $i)
		echo $(($prime + $prime)) > i2
		i2=$(<i2)
		prime2=$(matho-primes -c 1 -u $i2)
		echo $(($prime * $prime2)) > fact
		fact=$(<fact)
		sed -i "s/toFactor=.*/toFactor=$fact/g" /notebooks/qrack/pyqrack-jupyter/shor.py
		ipython3 /notebooks/qrack/pyqrack-jupyter/shor.py > factoring
		cat factoring | grep 'Factors found'
		echo 'Prime #1:   ' $prime 'Prime #2:   ' $prime2 'Multiplied: ' $fact
		echo ' '
	done
