shc -f ./src/msm.sh

if [ -f ./src/msm.sh.x ]; then
    mkdir bin/
    mv ./src/msm.sh.x ./bin/msm
    rm ./src/msm.sh.x.c

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
