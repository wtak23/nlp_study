#!/usr/bin/env bash
#=============================================================================#
# do all the make at once
#=============================================================================#
export PATH="/cygdrive/c/Users/takanori/Anaconda2:$PATH" # <- when running script from sublime-build, python calls from /usr/bin/python.  i want anaconda python to run
export PATH="/cygdrive/c/Users/takanori/Anaconda2/Scripts:$PATH" 
# echo $PATH
# which python # <- verify python from anaconda is running
make clean
# rm -r ./source/generated*
# # mkdir ./source/generated
# # mkdir ./source/generated/generated
# # cp -r ./source/_templates ./source/generated/
# # cp -r ./source/_templates ./source/generated/generated/
make html

# "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
# "/cygdrive/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" 

# exit 0
# --- browse result in chrome? --- #
# BROWSE=false
# if [[ ! BROWSE ]]; then exit 0; fi
if [[ $(uname -o) == 'Cygwin' ]]; then
  "/cygdrive/C/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
      $(cygpath -w ${PWD}/build/html/index.html)
else
    google-chrome ./build/html/index.html      
fi
