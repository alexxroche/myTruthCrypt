## Usage ##

1. download myTruthCrypt: wget https://raw.githubusercontent.com/alexxroche/myTruthCrypt/master/myTruthCrypt )
2. install dependends: sudo apt-get install -y bash sed util-linux cryptsetup e2fsprogs coreutils dmesg losetup awk argon2 tr sha1sum
{ optional
  3. Open myTruthCrypt in a text editor
  4. Edit the size of the container (size= Number of Megabytes)
  5. Check that you are happy with the name for the file that will contain your encrypted stuff, ( disk_img )
  6. change the ( mount_point ) if you want your encrypted file system located somewhere else
  7. ensure that you have can read and write to ( smb ) (where the encrypted file will live while in use
}
8. Save myTruthCrypt and run it.

If you do nothing and run myTruthCrypt it will:
  create a 500Mb file called .encryptedVol_500M_001 in ~/.smb
  and mount it on ~/export where you can use it like any regular directory.

Once you are done you can "lock" the encryption with:

myTruthCrypt -u

This means that you can store 500Mb of your most important files.

N.B. Ensure that you have a backup of the myTruthCrypt script, (as it will contain encrypted data that is used
to lock your TruthCrypt, (also make sure that you have something that backs up ~/.smb/.encryptedVol_500M_001
because if that is damaged you may loose all of the files that it contains.)

N.N.B. There is NO recovery procedure and no backdoor, (that I can find.)

It is recommended that you have your password created with something like:

`apg -a 0 -n1 -m128 -M sNCL`

2017 Just found https://files.dyne.org/tomb/ exists

## myTruthCrypt ##

This is a sketch of an idea. I wanted to simplify the creation, management and use of dm-crypt and LUKS encrypted volumes.

The program cryptsetup has done the heavy lifting, so this is just an opinionated wrapper.

Incidentally I wanted to be able to have a perl __DATA__ style in bash, (for which I created an ini style solution, but it is far from perfect.)
That said, this can be ported to your preferred language. Feel free to implement a proper ~/.config/myTrueCrypt style config.

The default is a single self-contained script for creating and mounting a single encrypted container that can be mounted.
Your version may require the ability to mount multiple encrypted containers and deal with multiple users, (for that I would recommend changing the name to reflect the functionality: mtcMultiContainer mtcConfSanity).


## Dependents ##

This version uses:

bash    >= 4.3.30  || dash >= 0.5.8-2.4 (almost works with ksh and probably works with some other shells)
GNU sed >= 4.2.2
sudo    >= 1.8.10p3
OpenSSL >= 1.0.1t # hmac-sha512, salted-aes-256-cbc, aes-cbc-essiv, hmac-rmd160, 
# Though you can use camellia256 cast blowfish seed, or implement them natively or use
# (maybe) https://gitlab.com/gan.xijun/openssl-twofish 
util-linux  >= 2.25.2 # losetup, umount
cryptsetup  >= 1.6.6
e2fsprogs   >= 1.42.12 # mke2fs
GNU coreutils >= 8.23 # head, cut, base64, whoami, dd, mkdir, chown, basename
awk

grep rdfa:deps myTruthCrypt #for a full list
# many could be replaced with bash native, but some portability was felt desirable

# recomended
argon2 (for passphrase stretching) or scrypt, (or in a pinch bcrypt)
# myTruthCrypt has some hardcoded argon2 settings. Feel free to ramp those up for your platform
# (though obviously not for existsing containers as that will lock you out.)

/dev/urandom  # just letting future me know for your SELinux config
# Though older versions may work, and future developers may break backward compatibility,
# it works for now.

## Install deps ##
# with something like:
apt-get update; aptitude install -y coreutils bash sed sudo openssl util-linux cryptsetup e2fsprogs argon2
yum install -y coreutils bash sed sudo openssl util-linux cryptsetup e2fsprogs argon2

## Description ##

myTruthCrypt is here to create, mount, unmount and protect your data.
It makes encryption so easy that you can create a separate encrypted container for each fragment of data.
It delivers the usual Unix freedom, (so you will have to select the best passphrase for your data.)
It offers NO KNOWN recovery, (other than brute-force) for lost passphrases.
BACKUP is still YOUR top priority. It MUST be automated and should be done when the containers are unmounted.
(Though I've successfully backed up a mounted container.)

## How to ##

... (create/use/panic/understand)

### create ###
just run it. If you want to change the default presumptions then please do; though you might shoot yourself in the foot if you do, (one of the costs of freedom.)
            You should be fairly safe with changing the volume size, but make sure you have enough space.
            It will sometimes happily create a 2048 Terabyte vol on a 64Gig partition; you will lose data if you use that. 

### use ###
just run it any time, (to mount) though the creation process also mounts and leaves the encrypted container live and ready for use.

### panic/lock/unmount ###
run it with -u (actually -umount -unmount -U also work)

## What does it actually do? ##
It is meant to create an encrypted object that can be mounted and used to contain your data. These file containers can then safely be backed up to any old insecure location. (Though unmount them first to be safe.)

############
### Bugs ###
############
#
# TOTALLY fails to check that argon2 output, $key and $hmac are not = '' (which would be bad)
#
# says "bad magic number" which isn't helpful to users
#
# If you remove the encrypedVol or have someone elses' keys this does not fail cleanly
#
# should warn if trying to create a large .encVol 
# (as it depends upon random-ish data, and can take a while)
############
### TODO ###
############
# We should to be able to pass volume_names, volume_sizes, and even passphrases, as arguments
# [-protect] function that will:
#  + size up a directory; 
#  + create a volume big enough to hold it; 
#  + move the data into it and then create a mount point where the old directory was.
# There should be a way to be able to update passphrases
# We need a way to manage multiple volumes. e.g. --mount-all
#  Check that this works when the .encVol is stored in Tahoe-lafs or glusterfs or ceph
# 

## Philosophy ##
Should you create test files and then scrub their key so that everyone else has the same deniability to protect their data?

MIT version 1.0 licence
