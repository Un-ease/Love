#!/bin/bash

# Colors
RED=$(tput setaf 1)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

# Get terminal dimensions
cols=$(tput cols)
lines=$(tput lines)

# Center text function
center() {
  local str="$1"
  printf "%*s\n" $(( (${#str} + cols) / 2 )) "$str"
}

# Clear terminal at start
clear

# Lyrics to be displayed
lyrics=(
  "My love will always stay by you"
  "♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥"
  "I'll keep it safe, so don't you worry a thing"
  "I'll tell you I love you more"
  "It's stuck with you forever.... so promise you won't let it go"
  "I'll trust the universe will always bring me to you"
  "I'll imagine we fell in love"
  "I'll nap under moonlight skies with you"
  "I think I'll picture us, you with the waves"
  "The ocean's colors on your face"
  "I'll leave my heart with your air"
  "So let me fly with you"
  "Will you be foreverrrrrr with me?"
)

# Print centered lyrics with typewriter effect
for i in "${!lyrics[@]}"; do
  line="${lyrics[$i]}"
  
  # Alternate colors
  case $((i % 3)) in
    0) color=$RED ;;
    1) color=$MAGENTA ;;
    2) color=$CYAN ;;
  esac

  # Position cursor at vertical center
  tput cup $((lines/2)) 0
  tput el  # Clear line
  
  # Calculate starting position for horizontal centering
  col_pos=$(( (cols - ${#line}) / 2 ))
  
  # Typewriter effect
  for (( j=0; j<${#line}; j++ )); do
    tput cup $((lines/2)) $((col_pos + j))
    echo -ne "${color}${line:$j:1}${RESET}"
    sleep 0.1
  done
  sleep 0.5

  if [ $i -eq 5 ]; then
    # Print heart shape after the lyrics
    sleep 0  # No pause before the heart

    # Speed up by reducing delays and optimizing printing
    heart_delay=0.01  # Reduced from 0.04 (4x faster)
    
    # Build the entire heart in memory first, then print
    heart_lines=()
    for (( y=10; y>-10; y-- )); do
        line=""
        for (( x=-30; x<30; x++ )); do
            result=$(awk -v x=$x -v y=$y 'BEGIN {
                fx = x / 10.0;
                fy = y / 7.0;
                val = (fx*fx + (5*fy/4 - sqrt((fx >= 0 ? fx : -fx)))^2);
                print (val < 1.2) ? "1" : "0"
            }')
            
            if [[ $result -eq 1 ]]; then
                line+="${RED}♥${RESET}"
            else
                line+=" "
            fi
        done
        heart_lines+=("$line")
    done
    
    # Print all lines at once (much faster)
    printf "%s\n" "${heart_lines[@]}"
    
    # Alternatively for line-by-line with minimal delay:
    # for line in "${heart_lines[@]}"; do
    #     echo -e "$line"
    #     sleep $heart_delay
    # done
  fi
done

# Romantic explosion effect
explosion() {
  local chars=("♥" "♦" "♣" "♠" "★" "☆" "✧" "✦")
  local color_array=("$RED" "$MAGENTA" "$CYAN" "$WHITE")
  for i in {1..150}; do
    local x=$((RANDOM % cols))
    local y=$((RANDOM % lines))
    local char=${chars[$RANDOM % ${#chars[@]}]}
    local color=${color_array[$RANDOM % ${#color_array[@]}]}
    
    tput cup $y $x 2>/dev/null
    echo -ne "$color$char$RESET"
  done
}

# Final proposal message
final_message() {
  local msg=' ♥ Whats up shawty? ♥ '
  local border=$(printf "%${#msg}s" "" | tr ' ' '=')
  
  tput cup $((lines/2 - 2)) 0
  center "$border"
  tput cup $((lines/2 - 1)) 0
  center "$msg"
  tput cup $((lines/2)) 0
  center "$border"
}

# Create explosion effect
for i in {1..3}; do
  explosion
  sleep 0.2
done

# Show final message
final_message

# Keep on screen
sleep 5
clear

