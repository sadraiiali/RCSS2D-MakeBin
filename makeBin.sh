#!/bin/bash
AgentPath='/home/alitbs/Downloads/s/agent2d-3.1.1';
LibPath='/home/alitbs/Downloads/librcsc-4.1.0';
TeamNameMain='KN2C'
TeamNameYear='2018'
TeamName="$TeamNameMain$TeamNameYear";
AgentName='sample_player';
CoachName='sample_coach';
nowPath=`pwd`


OutPath=`pwd`
OutName='KN2C2018-Bin'

Signature='
$$\   $$\ $$\   $$\  $$$$$$\   $$$$$$\
$$ | $$  |$$$\  $$ |$$  __$$\ $$  __$$\
$$ |$$  / $$$$\ $$ |\__/  $$ |$$ /  \__|
$$$$$  /  $$ $$\$$ | $$$$$$  |$$ |
$$  $$<   $$ \$$$$ |$$  ____/ $$ |
$$ |\$$\  $$ |\$$$ |$$ |      $$ |  $$\
$$ | \$$\ $$ | \$$ |$$$$$$$$\ \$$$$$$  |
\__|  \__|\__|  \__|\________| \______/

----------------------------------------
          ***HELIOS_based***
----------------------------------------
by :
    a.sadreddin
    a.sadraii
    m.moazen
    s.nazari
    a.tabasi
    +
----------------------------------------
'
function makefinalResult {
    mkdir finalResult
    cd finalResult
    OutPath=`pwd`
    cd 
    cd $nowPath
}
function main {
    defualts_='Y';
    defualts='';
   
    while [ "$defualts" != "y" ] && [ "$defualts" != "n" ] && [ "$defualts" != "Y" ] && [ "$defualts" != "N" ]
    do
      read -p "Use Defualts ? (Y|n) " defualts__;
      defualts=${defualts__:-$defualts_};
    done
    
    echo $nowPath
    if [ "$defualts" ==  "n" ] || [ "$defualts" ==  "N" ];then
      getNames;
    fi
    Dir="$OutPath/$OutName";
    echo "$OutPath"
    echo "$OutName"
    echo "$Dir"
    makeOut;
    makeLib;
    makeAgent;
    makeConfs;
    makeStarts;
    makeArchive;
    OutFileSize=$(du -h "$Dir/Dist/$OutName.tar.gz" | awk '{print $1}')
    echo "-> Tar File Size: $OutFileSize"
    echo ""
    testBinBool='n'
    read -p "--> do you want to test ? (y|N) " testBinBool_
    testBinBool=${testBinBool_:-$testBinBool};
    if [ $testBinBool == 'y' ] || [  $testBinBool == 'Y' ];then
      testBin;
    fi
    echo ""
    echo ""
    echo "-------------------------------------.";
    echo "             Done ! Have Fun :)      |";
    echo "-------------------------------------'";
    echo ""
    exit
}
function testBin {
  pkill rcssserver;
  rcssserver>/dev/null&
  cd $Dir;
  ./startAll>&- 2>&-&
  rcssmonitor>&- 2>&-&
}
function makeArchive {
  echo ""
  echo "-----------Make Archive--------------";
  echo ""
  cd $Dir;
  cd ..;
  tar -czf $Dir/$TeamName-Bin.tar.gz $TeamName-Bin;
  mkdir $Dir/Dist;
  mv $Dir/$TeamName-Bin.tar.gz $Dir/Dist
  echo "-> Archive Maked Successfully."
}
function makeStarts {
  echo ""
  echo "------------Make Starts---------------";
  echo ""
  start="#!/bin/sh

HOST=\$1
BASEDIR=\$2
NUM=\$3
DIR=\`dirname \$0\`

LIBPATH=\"\${DIR}/Lib\"
if [ x\"\$LIBPATH\" != x ]; then
  if [ x\"\$LD_LIBRARY_PATH\" = x ]; then
    LD_LIBRARY_PATH=\$LIBPATH
  else
    LD_LIBRARY_PATH=\$LIBPATH:\$LD_LIBRARY_PATH
  fi
  export LD_LIBRARY_PATH
fi

teamname=\"$TeamName\"

player=\"\${DIR}/$AgentName\"
coach=\"\${DIR}/$CoachName\"

config=\"\${DIR}/player.conf\"
config_dir=\"\${DIR}/Formations\"
coach_config=\"\${DIR}/coach.conf\"

opt=\"--player-config \${config} --config_dir \${config_dir}\"
opt=\"\${opt} -h \${HOST} -t \${teamname}\"

coachopt=\"--coach-config \${coach_config}\"
coachopt=\"\${coachopt} -h \${HOST} -t \${teamname}\"

cd \$BASEDIR

case \$NUM in
    1)
        \$player \$opt -g
        ;;
    12)
        \$coach \$coachopt
        ;;
    *)
        \$player \$opt
        ;;
esac
  ";
  startAll="#!/bin/sh
echo '
$Signature
'
DIR=\`dirname \$0\`
\${DIR}/start 127.0.0.1 . 1 &
sleep 1;
\${DIR}/start 127.0.0.1 . 2 &
\${DIR}/start 127.0.0.1 . 3 &
\${DIR}/start 127.0.0.1 . 4 &
\${DIR}/start 127.0.0.1 . 5 &
\${DIR}/start 127.0.0.1 . 6 &
\${DIR}/start 127.0.0.1 . 7 &
\${DIR}/start 127.0.0.1 . 8 &
\${DIR}/start 127.0.0.1 . 9 &
\${DIR}/start 127.0.0.1 . 10 &
\${DIR}/start 127.0.0.1 . 11 &
\${DIR}/start 127.0.0.1 . 12 &
"
  echo "$start">$Dir/start;
  echo "$startAll">$Dir/startAll;
  chmod +x $Dir/start;
  chmod +x $Dir/startAll;
  echo "-> Starts added Successfully."

}
function makeConfs {
  echo ""
  echo "------------Make Confs---------------";
  echo ""
  coachConfs="
# coach agent configuration file

team_name : $TeamName
version : 14

coach_name : $CoachName
use_coach_name : off

interval_msec : 50
server_wait_seconds : 5

host : localhost
port : 6002

use_eye : on
hear_say : on

use_team_graphic : off
max_team_graphic_per_cycle : 32

debug_system
debug_sensor
debug_world
debug_action
debug_intercept
debug_kick
debug_hold
debug_dribble
debug_pass
debug_cross
debug_shoot
debug_clear
debug_block
debug_mark
debug_positioning
debug_role
debug_plan
debug_team
debug_communication
debug_analyzer
debug_action_chain
  ";
  playerConfs="
# player agent configuration file

team_name : $TeamName
version : 14

server_wait_seconds : 5
normal_view_time_thr : 20
synch_see : on

host : localhost
port : 6000

use_communication : on
hear_opponent_audio : off

#debug
log_dir : /tmp

debug_log_ext : .log

debug_system
debug_sensor
debug_world
debug_action
debug_intercept
debug_kick
debug_hold
debug_dribble
debug_pass
debug_cross
debug_shoot
debug_clear
debug_block
debug_mark
debug_positioning
debug_role
debug_plan
debug_team
debug_communication
debug_analyzer
debug_action_chain
  ";
  echo "$coachConfs">$Dir/coach.conf;
  echo "$playerConfs">$Dir/player.conf;
  echo "-> Confs added Successfully."

}
function makeAgent {
  echo ""
  echo "-----------Make Agent----------------";
  echo ""

  check='a';
  makeCheck=1;
  while [[ makeCheck -ne 0 ]]; do
    while [ "$check" != "y" ] && [ "$check" != "n" ] && [ "$check" != "Y" ] && [ "$check" != "N" ]
    do
      check='y';
      read -p "Clean Make Agent ?(Y|n)" check_;
      check=${check_:-$check};
    done
    if [ "$check" == "y" ] || [ "$check" == "Y" ];then
      check2='a';
      while [ "$check2" != "y" ] && [ "$check2" != "n" ] && [ "$check2" != "Y" ] && [ "$check2" != "N" ]
      do
        check2='n';
        read -p "print Full Log ?(y|N)" check2_;
        check2=${check2_:-$check2};
      done
      if [ "$check2" == "n" ] || [ "$check2" == "N" ];then
        cd $AgentPath;
        make clean>/dev/null;
        ./configure  --with-librcsc=$Dir/Lib -q;
        make -j8 --silent;
	echo "$?" 
      else
        cd $AgentPath;
        make clean;
        ./configure --with-librcsc=$Dir/Lib;
        make -j8;
      fi
    fi
    if [ "$check" == "n" ] || [ "$check" == "N" ];then
      check2='a';
      while [ "$check2" != "y" ] && [ "$check2" != "n" ] && [ "$check2" != "Y" ] && [ "$check2" != "N" ]
      do
        check2='n';
        read -p "print Full Log ?(y|N)" check2_;
        check2=${check2_:-$check2};
      done
      if [ "$check2" == "n" ] || [ "$check2" == "N" ];then
        cd $AgentPath;
        ./configure  --with-librcsc=$Dir/Lib -q;
        make -j8 --silent;
      else
        cd $AgentPath;
        ./configure --with-librcsc=$Dir/Lib;
        make -j8;
      fi
    fi

    echo "-> Agent Successfully Maked !"

    cp $AgentPath/src/$AgentName $Dir/$AgentName
    makeCheck=$?
    if [[ makeCheck -ne 0 ]];then
      echo "-!-> Ops ! something wrong in copy Agent ! enter to retry."
      read p
      break;
    else
      echo "-> Agent Successfully copied !"
    fi
    cp $AgentPath/src/$CoachName $Dir/$CoachName
    makeCheck=$?
    if [[ makeCheck -ne 0 ]];then
      echo "-!-> Ops ! something wrong in copy Coach ! enter to retry."
      read p
      break;
    else
      echo "-> Coach Successfully Copied !"
    fi
    cp $AgentPath/src/formations-dt/* $Dir/Formations/
    makeCheck=$?
    if [[ makeCheck -ne 0 ]];then
      echo "-!-> Ops ! something wrong in copy Formations ! enter to retry."
      read p
      break;
    else
      echo "-> Formations Successfully Copied !"
    fi
  done

}
function makeLib {
  echo ""
  echo "----------Make Lib---------------";
  echo ""
  makeCheck=1;
  while [[ makeCheck -ne 0 ]]; do
    check='a';
    while [ "$check" != "y" ] && [ "$check" != "n" ] && [ "$check" != "Y" ] && [ "$check" != "N" ]
    do
      check='n';
      read -p "Clean Make Lib ?(y|N)" check_;
      check=${check_:-$check};
    done
    if [ "$check" == "y" ] || [ "$check" == "Y" ];then
      check2='a';
      while [ "$check2" != "y" ] && [ "$check2" != "n" ] && [ "$check2" != "Y" ] && [ "$check2" != "N" ]
      do
        check2='n';
        read -p "print Log ?(y|N)" check2_;
        check2=${check2_:-$check2};
      done
      if [[ "$check2" == "n" ]] || [[ "$check2" == "N" ]];then
        cd $LibPath;
        make clean>&- 2>&-;
        ./configure  --prefix="$Dir/Lib" -q;
	echo "$?" 
        make -j8 --silent;
        makeCheck=$?;
        if [[ makeCheck -ne 0  ]];then
          echo "-!-> Make Error ! enter to retry."
          read p
          continue;
        fi
        make install>/dev/null;
      fi
      if  [[ "$check2" == "y" ]] || [[ "$check2" == "Y" ]];then
        cd $LibPath;
        make clean;
        ./configure --prefix="$Dir/Lib";
        make -j8 --silent;
        makeCheck=$?
        if [[ makeCheck -ne 0 ]];then
          echo "-!-> Make Error ! enter to retry."
          read p
          continue;
        fi
        make install;
      fi
    else
      check2='a';
      while [ "$check2" != "y" ] && [ "$check2" != "n" ] && [ "$check2" != "Y" ] && [ "$check2" != "N" ]
      do
        check2='n';
        read -p "print Log ?(y|N)" check2_;
        check2=${check2_:-$check2};
      done
      if [ "$check2" == "n" ] || [ "$check2" == "N" ];then
        cd $LibPath;
        ./configure --prefix="$Dir/Lib" -q;
        make install>/dev/null;
      else
        cd $LibPath;
        ./configure --prefix="$Dir/Lib";
        make install ;
      fi
    fi
  cd $Dir/Lib;
    rm -r include;
    rm -r bin;
    mv lib/* .;
    rm -r lib;
    rm -r pkgconfig;
	
    makeCheck=$?
    if [[ makeCheck -eq 0 ]];then
      echo "-> Lib files is OK ."
    fi
  done
}
function getNames {
  echo ""
  echo "-----------Get Inputs----------------";
  echo ""

  echo "give me the path of Agent: (defualt: $AgentPath)"
  read -p "->  " AgentPath_;
  AgentPath=${AgentPath_:-$AgentPath};
  echo ""

  echo "give me the path of Lib: (defualt: $LibPath)";
  read -p "->  " LibPath_;
  LibPath=${LibPath_:-$LibPath};
  echo ""

  echo  "Team Main Name: (defualt: $TeamNameMain)";
  read -p "->  " TeamNameMain_;
  TeamNameMain=${TeamNameMain_:-$TeamNameMain};
  echo ""

  echo  "Team Name Year: (defualt: $TeamNameYear)";
  read -p "->  " TeamNameYear_;
  TeamNameYear=${TeamNameYear_:-$TeamNameYear};
  echo ""

  check='z';
  TeamName="$TeamNameMain$TeamNameYear";
  while [ "$check" != "y" ] && [ "$check" != "Y" ]
  do
    echo "-------------------------------------";
    echo  "Team Name: $TeamName";
    echo "-------------------------------------";
    echo ""
    check='y';
    read -p "is TeamName correct ?(Y|n) " check_;
    check=${check_:-$check};
    if [ "$check" == "n" ] || [ "$check" == "N" ];then
      read -p "TeamName: " TeamName;
    fi
  done

  echo "Agent Name: (defualt: $AgentName) ";
  read -p "->  " AgentName_;
  AgentName=${AgentName_:-$AgentName};
  echo ""

  echo  "Coach Name: (defualt: $CoachName) ";
  read -p "->  "  CoachName_;
  CoachName=${CoachName_:-$CoachName};
  echo ""

  CheckInputs;
}
function CheckInputs {
  echo ""
  echo "---------------Check-----------------";
  echo "AgentPath : \"-$AgentPath\"";
  echo "LibPath : \"$LibPath\"";
  echo "TeamName : \"$TeamName\"";
  echo "AgentName : \"$AgentName\"";
  echo "CoachName : \"$CoachName\"";
  echo "OutPath : \"$OutPath\""
  echo "-------------------------------------";
  echo "";
  check='a';
  while [ "$check" != "y" ] && [ "$check" != "n" ] && [ "$check" != "Y" ] && [ "$check" != "N" ]
  do
    check='y';
    read -p "is that correct ?(Y|n)" check_;
    check=${check_:-$check};
  done
  if [ "$check" == "n" ] || [ "$check" == "N" ];then
    getNames;
  fi
}
function makeOut {
  echo ""
  echo "----------Make Bin Dir----------------";
  echo ""
  OUT=1;
  
  while [[ OUT != 0 ]]; do
    mkdir $Dir>&- 2>&-
    OUT=$?
    if [ $OUT == 0 ];then
      echo "-> OutDir Created !";
      break;
    else
      remove='Y';
      echo "-!-> Can't Make Dir !";
      read -p "remove old \"$TeamName-Bin\" ?(Y|n) " remove_;
      remove=${remove_:-$remove};
      if [ $remove == 'y' ] || [ $remove == 'Y' ];then
        rm -r $Dir;
        rmStat=$?;
        if [ $rmStat == 0 ];then
          echo "old -$TeamName-Bin- folder removed !";
        else
          echo "-!-> Cant remove old -$TeamName-Bin-";
        fi
      fi
    fi
  done
  mkdir "$Dir/Lib";
  echo "-> Lib folder created."
  mkdir "$Dir/Formations";
  echo "-> Formations folder created.";

}
main
