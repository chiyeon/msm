echo "Checking for previous versions"

# Check for previous versions of the program
if [ -f /usr/local/bin/msm ]; then
    echo "Found previous msm installation"
    ./uninstall.sh || {
        echo "Couldn't uninstall. Run ./uninstall.sh before continuing"
        exit 0
    }
fi

cp msm.sh msm

# Copy the binary to /usr/local/bin
if [ -f ./msm ]; then
    { # try
        sudo mv ./msm /usr/local/bin/ &&
            echo "Done. Try running 'msm' in the console!"
    } || { #catch
        echo "Couldn't copy msm to /usr/local/bin/"
    }
else
    echo "Failed to compile."
fi
