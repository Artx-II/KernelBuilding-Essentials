# Session settings
# By Artx/Stayn <jesusgabriel.91@gmail.com>

# First Run
if [ ! -f ./resources/other/firstrun ]; then
touch ./resources/other/firstrun
echo " "
echo -e "$GREEN - It seems that you're running this program for the first time"
echo -e "   Lets install some necessaty stuff..."
installtools
echo -e "   Done, let's begin with some initial configuration..."

# Generate enviroment folders
checkfolders
checkenvironment
megacheck

# If checkenviroment exports CERROR=1 then, crosscompiler isn't configured
# because it's the first run, but, if it's configured before the first run
# then, there's no need for help
if [ "$CERROR" =  1 ]; then
  echo -e "$WHITE - There's no CrossCompiler available for the KernelBuilding process"
  echo -e "   But don't worry, this program will prompt to you which one you want"
  echo -e "   to download (arm or arm64) for your future buildings!"
  echo " "
fi

# Same has the above code, if checkenviroment doesn't detects the DTB tool, then
# this time, the user deleted it or its corrupt, if that's the case, the user must
# download dtbToolLineage again or re-download this script
if [ "$NODTB" = 1 ]; then
  echo -e "$RED - dtbToolLineage not found... this is is beacuse its corrupt or the user "
  echo -e "   deleted it, please, download it again or re-download this program"
fi

echo -e "$WHITE - Your Kernel source goes in the ./source folder, you can download there all the"
echo -e "   kernel sources you want, this program will prompt you which one you're "
echo -e "   going to build every session"
echo " "
echo -e " - Also, every session this program will prompt to you things like the kernel name, version,"
echo -e "   target android, build type, etc... You can skip all of this by enabling the variable "
echo -e "   'DSENABLED' in ./defaultsettings.sh and configuring it at your please, this program has"
echo -e "   been made to make everything you need automatically."
echo -e "$GREEN"
read -p "Press enter to continue..."
echo " "
echo -e "$WHITE - First run is done, run the command 'kbhelp' for more information and run this"
echo -e "   program again!"
export FRF=1
return 1
fi

# Clear Variables (Just in case)
unset KERNELNAME; unset TARGETANDROID; unset VERSION; unset VARIANT;
unset BLDTYPE; unset P; unset; unset CLR

# Prompt for data
echo " "
echo -e "$GREEN - Please, enter the necessary data for this session...$WHITE"
echo " "
read -p "   Kernel Name: " KERNELNAME; export KERNELNAME
read -p "   Target Android OS: " TARGETANDROID; export TARGETANDROID
read -p "   Version: " VERSION; export VERSION
read -p "   Variant: " VARIANT; export VARIANT
read -p "   Debug Kernel Building? [y/n]: " KKDEBUG
if [ $KKDEBUG = y ] || [ $KKDEBUG = Y ]; then
  export KDEBUG=1
fi

#until [ "$BLDTYPE" = A ] || [ "$BLDTYPE" = K ]; do
#  read -p "   Enter Build Type (A = AROMA; K = AnyKernel): " BLDTYPE
#  if [ $BLDTYPE != A ] && [ $BLDTYPE != K ]; then
#    echo " "
#    echo -e "$RED - Error, invalid option, try again..."
#    echo -e "$WHITE"
#  fi
#done
BLDTYPE=K # Aroma is still not available

# Get the ARCH Type
echo -e "$GREEN - Choose ARCH Type (arm for 32bits and arm64 for 64bits Devices)"
until [ "$ARMT" = 1 ] || [ "$ARMT" = 2 ]; do
  echo " "
  read -p "   Your option [1/2]: " AKBO
  if [ $ARMT != 1 ] && [ $ARMT != 2 ]; then
    echo " "
    echo -e "$RED - Error, invalid option, try again..."
    echo -e "$WHITE"
  fi
done
if [ "$ARMT" = 1 ]; then
  export ARCH=arm
elif [ "$ARMT" = arm64 ]; then
  export ARCH=arm64
fi

# This will export the correspondent CrossCompiler for the ARCH Type
if [ "$ARCH" = arm ]; then
  CROSSCOMPILE=$CDF/resources/crosscompiler/arm/bin/arm-eabi- # arm CrossCompiler
  # Check
  if [ ! -f "$CROSSCOMPILE"gcc ]; then
    echo -e "$RED - Cross Compiler not found ($CROSSCOMPILE) "
    downloadcc
  fi
elif [ "$ARCH" = arm64 ]; then
  CROSSCOMPILE=$CDF/resources/crosscompiler/arm64/bin/aarch64-linux-android-
  # Check 
  if [ ! -f "$CROSSCOMPILE"gcc ]; then
    echo -e "$RED - Cross Compiler not found ($CROSSCOMPILE) "
    downloadcc
  fi
fi

if [ "$BLDTYPE" = K ]; then
  BTYPE=AnyKernel
echo " "
echo -e "$GREEN - Choose an option for $BTYPE Installer: "
echo -e "$WHITE   1) Use local $BTYPE Template"
echo -e "   2) Download a Template from your MEGA (If MEGA isn't configured"
echo -e "      this will initialize a 'megacheck' command)"
until [ "$AKBO" = 1 ] || [ "$AKBO" = 2 ]; do
  echo " "
  read -p "   Your option [1/2]: " AKBO
  if [ $AKBO != 1 ] && [ $AKBO != 2 ]; then
    echo " "
    echo -e "$RED - Error, invalid option, try again..."
    echo -e "$WHITE"
  fi
done

if [ $AKBO = 1 ]; then
  templates_config
fi

if [ $AKBO = 2 ]; then
  export DLZIPS=1
  zipmegapath
fi
fi

echo " "
echo -e "$GREEN - Select a Kernel Source folder...$WHITE"
cd source
select d in */; do test -n "$d" && break; echo " "; echo -e "$RED>>> Invalid Selection$WHITE"; echo " "; done
echo -e "   (If you think that this isn't the Kernel Source folder, run this script again"
echo -e "    or define the source path in 'P' variable"
cd $CDF
 -e "$WHITE"
P=$CDF/source/$d

read -p "   Make dt.img? (Device Tree Image) [y/n]: " MKDTB
if [ $MKDTB = y ] || [ $MKDTB = Y ]; then
  export MAKEDTB=1
fi

read -p "   Clear Source on every Build? [y/n]: " CLRS
if [ $CLRS = y ] || [ $CLRS = Y ]; then
  export CLR=1
fi

echo " "
echo -e "$GREEN - Config Done, now you can start Building! $WHITE"
echo -e "   If you need help run 'kbhelp' or see './help.txt' file for more information"
echo " "
read -p "Press enter to continue..."
