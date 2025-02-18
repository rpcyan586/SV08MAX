#!/bin/bash

#创建续打文件夹
mkdir -p ~/printer_data/gcodes/plr

#获取源文件路径
filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/sovol/klipper_config/saved_variables.cfg)
filepath=$(printf "$filepath")
echo "filepath=$filepath"
last_file=$(sed -n "s/.*last_file *= *'\([^']*\)'.*/\1/p" /home/sovol/klipper_config/saved_variables.cfg)
last_file=$(printf "$last_file")
echo "$last_file"
plr=$last_file

#获取Z轴高度
#sed -i 's/Z\./Z0\./g' /home/sovol/mks_plr_height      #将Z.改为Z0.
sed -i 's/\"\./\"0\./g' /home/sovol/mks_plr_height   	#将".改为"0.
height=$(jq -r '.Z' /home/sovol/mks_plr_height)       #获取Z轴参数
commandline=$(jq -r '.commandline' /home/sovol/mks_plr_height)    #获取对应指令
echo "height=$height"	#打印出Z轴高度
echo "plr=$plr" 		#打印续打文件路径

PLR_PATH=~/printer_data/gcodes/plr
file_content=$(cat "${filepath}" | sed '/; Comgrow3D thumbnail begin/,/; Comgrow3D thumbnail end/d')
comment_content=$(grep '^;' "${filepath}" | sed '/; Comgrow3D thumbnail end/q')
echo "$file_content" | sed  's/\r$//' | awk -F"Z" 'BEGIN{OFS="Z"} {if ($2 ~ /^[0-9]+$/) $2=$2".0"} 1' > /home/sovol/plrtmpA.$$
echo "$comment_content" > ${PLR_PATH}/"${plr}"


#获取模型参数
grep ';TIME:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';Layer height:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINX:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINY:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MINZ:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXX:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXY:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';MAXZ:' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
grep ';Generated with Sovol Slicer' /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"
echo "SET_KINEMATIC_POSITION Z=$height" >> ${PLR_PATH}/"${plr}"


#升温防止扯模型
echo 'M109 S200' >> ${PLR_PATH}/"${plr}"

#抬升z轴，XY回零
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z5' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
echo 'G28 X Y' >> ${PLR_PATH}/"${plr}"

#获取温度
cat /home/sovol/plrtmpA.$$ | sed '/ Z'${height}'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M140 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M104 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_bed_temperature | sed -ne 's/.* = /M190 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
cat /home/sovol/plrtmpA.$$ | sed -ne '/;End of Gcode/,$ p' | tr '\n' ' ' | sed -ne 's/ ;[^ ]* //gp' | sed -ne 's/\\\\n/;/gp' | tr ';' '\n' | grep material_print_temperature | sed -ne 's/.* = /M109 S/p' | head -1 >> ${PLR_PATH}/"${plr}"
echo 'plr_temperature_wait' >> ${PLR_PATH}/"${plr}"
#开启风扇
echo 'M106 S255' >> ${PLR_PATH}/"${plr}"

#移动到续打点
f_value=10000
x_value=$(echo "$commandline" | grep -oP '(?<=X)[0-9.]+')
y_value=$(echo "$commandline" | grep -oP '(?<=Y)[0-9.]+')
z_value=$(echo "$commandline" | grep -oP '(?<=Z)[0-9.]+')
gcode_z="G0 Z$z_value"
gcode_xy="G0 F$f_value X$x_value Y$y_value"
echo $gcode_z >> ${PLR_PATH}/"${plr}"
echo $gcode_xy >> ${PLR_PATH}/"${plr}"

#复制后续gcode
sed -n "/$commandline/,\$p" /home/sovol/plrtmpA.$$ >> ${PLR_PATH}/"${plr}"

#删除中间文件
rm /home/sovol/plrtmpA.$$
