function go_ros() {
  export ROS_VERSION=2
  export ROS_PYTHON_VERSION=3

  # Check if ROS_DISTRO is set; if not, ask interactively
  if [[ -z "$ROS_DISTRO" ]]; then
    echo "ROS_DISTRO is not set."
    echo "Please enter your ROS 2 distribution (e.g., humble, jazzy, iron):"
    read -r distro_input

    # Basic validation
    if [[ -z "$distro_input" ]]; then
      echo "No ROS distribution entered. Aborting."
      return 1
    fi

    export ROS_DISTRO="$distro_input"
  fi

  echo "Your ROS distribution is: $ROS_DISTRO"
  echo "Attempting to source ROS environment..."

  # Try local, Fedora system, or /opt install
  if [[ -f "./install/setup.zsh" ]]; then
    echo "🧩 Found local workspace → sourcing ./install/setup.zsh"
    source ./install/setup.zsh
  elif [[ -f "/etc/fedora-release" ]]; then
    echo "🐧 Detected Fedora system → sourcing ROS 2 from /usr/lib64"
    if [[ -f "/usr/lib64/ros2-${ROS_DISTRO}/setup.zsh" ]]; then
      source "/usr/lib64/ros2-${ROS_DISTRO}/setup.zsh"
    else
      echo "⚠️  Could not find: /usr/lib64/ros2-${ROS_DISTRO}/setup.zsh"
      return 1
    fi
  elif [[ -f "/opt/ros/${ROS_DISTRO}/setup.zsh" ]]; then
    echo "📦 Sourcing /opt/ros/${ROS_DISTRO}/setup.zsh"
    source "/opt/ros/${ROS_DISTRO}/setup.zsh"
  else
    echo "❌ Could not find any ROS 2 setup file for '${ROS_DISTRO}'."
    echo "Please make sure ROS 2 is installed or sourced correctly."
    return 1
  fi

  # Setup Python argcomplete (if available)
  if command -v register-python-argcomplete &>/dev/null; then
    eval "$(register-python-argcomplete ros2)"
    eval "$(register-python-argcomplete colcon)"
  elif command -v register-python-argcomplete3 &>/dev/null; then
    eval "$(register-python-argcomplete3 ros2)"
    eval "$(register-python-argcomplete3 colcon)"
  else
    echo "⚠️  'register-python-argcomplete' not found; skipping autocompletion setup."
  fi

  python3 - <<'EOF'
import platform, os
print()
print(f"System: {platform.system()} {platform.release()}")
print(f"Python: {platform.python_implementation()} {platform.python_version()}")
print(f"   RMW: {os.environ.get('RMW_IMPLEMENTATION', '?')}")
print(f"   ROS: {os.environ.get('ROS_DISTRO', 'distro?')}")
print(f"🤖 Welcome to ROS on {platform.node()}")
print()
EOF
}
