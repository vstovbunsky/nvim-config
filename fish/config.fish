if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Homebrew path
set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH

# Set Vulkan SDK path
set -x VULKAN_SDK ~/VulkanSDK/1.3.290.0/macOS

# Add Vulkan SDK binaries to PATH
set -x PATH $VULKAN_SDK/bin $PATH

# Set DYLD_LIBRARY_PATH for dynamic libraries
set -x DYLD_LIBRARY_PATH $VULKAN_SDK/lib $DYLD_LIBRARY_PATH

# Set VK_ICD_FILENAMES for MoltenVK
set -x VK_ICD_FILENAMES $VULKAN_SDK/share/vulkan/icd.d/MoltenVK_icd.json

# Set VK_LAYER_PATH for validation layers
set -x VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d

# Initialize zoxide
zoxide init fish | source
