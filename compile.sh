shc -f ./src/msm.sh

if [ -f ./src/msm.sh.x ]; then
    mv ./src/msm.sh.x ./bin/msm
    rm ./src/msm.sh.x.c

    sudo cp ./bin/msm /usr/local/bin/

    echo "Done. Try running 'msm' in the console!"
else
    echo Failed to compile.
fi