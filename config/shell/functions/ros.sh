# Shared by bash and zsh: ROS ships a setup file per shell, so pick the matching one.

go_ros() {
  local shell_ext distro_input setup
  if [ -n "$ZSH_VERSION" ]; then
    shell_ext=zsh
  elif [ -n "$BASH_VERSION" ]; then
    shell_ext=bash
  else
    echo "go_ros: unsupported shell (need bash or zsh)" >&2
    return 1
  fi

  export ROS_VERSION=2
  export ROS_PYTHON_VERSION=3

  # Check if ROS_DISTRO is set; if not, ask interactively
  if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set."
    echo "Please enter your ROS 2 distribution (e.g., humble, jazzy, iron):"
    read -r distro_input

    # Basic validation
    if [ -z "$distro_input" ]; then
      echo "No ROS distribution entered. Aborting." >&2
      return 1
    fi

    export ROS_DISTRO="$distro_input"
  fi

  echo "Your ROS distribution is: $ROS_DISTRO"
  echo "Attempting to source ROS environment..."

  # Try local, Fedora system, or /opt install
  if [ -f "./install/setup.$shell_ext" ]; then
    echo "🧩 Found local workspace → sourcing ./install/setup.$shell_ext"
    . "./install/setup.$shell_ext"
  elif [ -f "/etc/fedora-release" ]; then
    setup="/usr/lib64/ros-${ROS_DISTRO}/setup.$shell_ext"
    echo "🐧 Detected Fedora system → sourcing ROS 2 from /usr/lib64"
    if [ -f "$setup" ]; then
      . "$setup"
    else
      echo "⚠️  Could not find: $setup" >&2
      return 1
    fi
  elif [ -f "/opt/ros/${ROS_DISTRO}/setup.$shell_ext" ]; then
    echo "📦 Sourcing /opt/ros/${ROS_DISTRO}/setup.$shell_ext"
    . "/opt/ros/${ROS_DISTRO}/setup.$shell_ext"
  else
    echo "❌ Could not find any ROS 2 setup file for '${ROS_DISTRO}'." >&2
    echo "Please make sure ROS 2 is installed or sourced correctly." >&2
    return 1
  fi

  # Setup Python argcomplete (if available); --shell emits zsh-native code under zsh
  if command -v register-python-argcomplete >/dev/null 2>&1; then
    eval "$(register-python-argcomplete --shell "$shell_ext" ros2)"
    eval "$(register-python-argcomplete --shell "$shell_ext" colcon)"
  else
    echo "⚠️  'register-python-argcomplete' not found; skipping autocompletion setup." >&2
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
