echo "Checking for previous versions"

if [ -f /usr/local/bin/msm ]; then
	echo "Found previous msm installation"
	./uninstall.sh || {
		echo "Couldn't uninstall. Run ./uninstall.sh before continuing"
		exit 0
	}
fi

shc -f ./msm.sh

if [ -f ./msm.sh.x ]; then
    mkdir bin/
    mv ./msm.sh.x ./bin/msm
    rm ./msm.sh.x.c

    echo "Compiled to /bin/msm/"

    {       # try
        sudo cp ./bin/msm /usr/local/bin/ &&
        echo "Done. Try running 'msm' in the console!"
    } || {  #catch
        echo "Couldn't copy msm to /usr/local/bin/"
    }
else
    echo Failed to compile.
fi
