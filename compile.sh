shc -f ./src/msm.sh

if [ -f ./src/msm.sh.x ]; then
    mv ./src/msm.sh.x ./bin/msm
    rm ./src/msm.sh.x.c

    echo Done. Outputted to bin/msm
else
    echo Failed to compile, file not found.
fi