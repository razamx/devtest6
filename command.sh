# Build Dependencies
#yum -y install gcc-c++
#yum install centos-release-scl
#yum install devtoolset-8-gcc devtoolset-8-gcc-c++
#scl enable devtoolset-8 -- bash

#yum -y install cmake
#yum -y install make
#yum -y install git
#yum -y install shellcheck
apt update
apt install gcc-c++
apt install centos-release-scl
apt install devtoolset-8-gcc devtoolset-8-gcc-c++
scl enable devtoolset-8 -- bash

apt install cmake
apt install make
apt install -y git 
apt install shellcheck



dirBuildSource=/ 
#home/ubuntu/src/tcc

printf "%s\n%s\n%s\n%s\n%s\n%s\n" \
"${dirBuildSource}/2021.3.0/" \
"${dirBuildSource}/build-host/" \
"${dirBuildSource}/build-target/" \
"${dirBuildSource}/libraries.compute.tcc-tools/" \
"${dirBuildSource}/libraries.compute.tcc-tools.docs/" \
"${dirBuildSource}/libraries.compute.tcc-tools.infrastructure/"

$ chmod -R 777 ${dirBuildSource}/build* ${dirBuildSource}/libraries*
$ chmod -R 755 ${dirBuildSource}/2021.3.0

dirBuildRoot=/
#home/tcc/build
#dockerImage=hub.docker.com/repository/docker
#echo "Using ${dockerImage} as source of Docker build container."
#dockerCommand="docker run -it -v ${dirBuildSource}:${dirBuildRoot}:z ${dockerImage}"
#echo "${dockerCommand}"
#eval "${dockerCommand}"

# ############################################################################

# Perform a "host build" (cmake + make).
# Note that ${dirBuildRoot}/build is used twice: for host build and again for target build.
# Doing this to minimize path differences between the host and target build results.
set -ex   
rm -rf ${dirBuildRoot}/build*  # remove folder with contents
mkdir ${dirBuildRoot}/build    # make directory with name
cd ${dirBuildRoot}/build       # change directory that name
#cmake -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${dirBuildRoot}/build/host -DHOST_STRUCTURE=ON -DPACKAGE_TYPE=PUBLIC ${dirBuildRoot}/libraries.compute.tcc-tools 

#make VERBOSE=1
#-j $(nproc) 2>&1 | tee ${dirBuildRoot}home/build/build_log.txt

#make VERBOSE=1  # 2>&1 | tee ${dirBuildRoot}/build/build_log.txt
#make doc -j $(nproc)
#make install -j $(nproc)

cd ..
mv ${dirBuildRoot}/build ${dirBuildRoot}/build-host

# Part two: turn the usr folder into a tar.gz file.

#rm -rf ${dirBuildRoot}/build/tcc_tools*.tar.gz
#tar --owner=root --group=root --exclude='usr/tests' -cvzf ${dirBuildRoot}/build/tcc_tools_target_2022.1.0.tar.gz usr

#  Part three: add efi module (by way of edk2 project).
set -ex
mkdir -p /opt
cd /opt
rm -rf edk2
git clone https://github.com/tianocore/edk2.git
cd edk2
git checkout tags/edk2-stable202105 -B edk2-stable202105
git submodule update --init
#make -C BaseTools

rm -rf ${dirBuildRoot}/build/edk2
cp -r /opt/edk2 ${dirBuildRoot}/build/
cd ${dirBuildRoot}/build
#make -C edk2/BaseTools
#cd edk2
#shellcheck source=/dev/null
#source edksetup.sh-
#patch -p1 < ${dirBuildRoot}/libraries.compute.tcc-tools.infrastructure/ci/edk2/tcc_target.patch
#sed -i "s+path_to_detector.inf+${dirBuildRoot}/libraries.compute.tcc-tools/tools/rt_checker/efi/Detector.inf+g" ShellPkg/ShellPkg.dsc
#build

cd ${dirBuildRoot}/build
rm -rf usr
#tar -xzf tcc_tools_target_2022.1.0.tar.gz
#cp edk2/Build/Shell/RELEASE_GCC5/X64/tcc_rt_checker.efi usr/share/tcc_tools/tools/
#tar -czvf tcc_tools_target_2022.1.0.tar.gz usr

# End of target build.
# Rename the "build" folder to "build-target"
cd ${dirBuildRoot}
mv ${dirBuildRoot}/build ${dirBuildRoot}/build-target