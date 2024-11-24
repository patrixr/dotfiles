--@meta
---
--- Run a glue script
---
---@param glue_file string the glue file to run
---
---
function glue(glue_file) end

---
--- Annotate the current group with some details
---
---@param brief string short explanation of the next step
---
---
function note(brief) end

---
--- Create a runnable group
---
---@param name string the name of the group to run
---@param fn function the function to run when the group is invoked
---
---
function group(name, fn) end

---
--- Creates a backup of a file
---
---@param path string the file to create a backup of
---
---
function backup(path) end

---@class BlockinfileParams
---@field path string the file to insert the block into
---@field block string the multi-line text block to be inserted or updated
---@field insertafter? string the multi-line text block to be inserted or updated
---@field insertbefore? string the multi-line text block to be inserted or updated
---@field marker? string the multi-line text block to be inserted or updated
---@field markerbegin? string the multi-line text block to be inserted or updated
---@field markerend? string the multi-line text block to be inserted or updated
---@field state boolean the multi-line text block to be inserted or updated
---@field backup? boolean the multi-line text block to be inserted or updated
---@field create? boolean the multi-line text block to be inserted or updated


---
--- Insert/update/remove a block of multi-line text surrounded by customizable markers in a file
---
---@param block_params BlockinfileParams the configuration for the block insertion
---
---
function blockinfile(block_params) end

---@class CopyOpts
---@field source string the file or folder to copy
---@field dest string the destination to copy to
---@field strategy? "replace"|"merge" a strategy for how to manage conflicts (defaults to merge)
---@field symlink? "deep"|"shallow"|"skip" how to handle symlinks (copy the content, copy the link, or the default skip)


---
--- Copies folder
---
---@param opts CopyOpts the copy options
---
---
function copy(opts) end

---@class HomebrewParams
---@field packages? string[] the homebrew packages to install
---@field taps? string[] the homebrew taps to install
---@field mas? string[] the homebrew mac app stores to install
---@field whalebrews? string[] the whalebrews install
---@field casks? string[] the homebrew casks to install


---
--- Installs Homebrew if not already installed
---
---
---
function homebrew_install() end

---
--- Marks a homebrew package for installation
---
---@param params HomebrewParams the packages to install
---
---
function homebrew(params) end

---
--- Upgrades all homebrew packages
---
---
---
function homebrew_upgrade() end

---
--- Run a shell command
---
---@param cmd string the shell command to run
---
---
function sh(cmd) end

---
--- Print a string
---
---@param obj any the message or object to log
---
---
function print(obj) end

---
--- Trims the extra indentation of a multi-line string
---
---@param txt string the text to trim
---
---@return string the trimmed text
---
function trim(txt) end

---
--- Uppercase the first letter of a string
---
---@param txt string the text to capitalize
---
---@return string the text with capitalized first letter
---
function capitalize(txt) end

---
--- Reads a file as a string
---
---@param path string the path of the file to read
---
---@return string the file content
---
function read(path) end


