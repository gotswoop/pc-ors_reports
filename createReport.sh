#!/bin/sh
if [-z $1 ]; then
    echo "No report specified. You must enter the name of the new report."
fi

REPORT = $1
echo "Create new report named '$REPORT'..."
RET = `mkdir $REPORT`
if ![ $RET == 0 ]; then
    echo "Error: Report directory already exists."
fi

echo "Done. Now edit the following:"
echo "\treports/$REPORTSfields.csv - 
