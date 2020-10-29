while true; do
    for i in {0..4} ; do
        echo "Requesting localhost:8000/?sleep=$i ..."
        curl -i "localhost:8000/?sleep=$i"
        echo ""
    done
done
