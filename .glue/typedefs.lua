--@meta
glue = {
}

---
--- Run a glue script
---
---@param glue_file string the glue file to run
---
---@return nil 
---
function glue.run(glue_file) end

---
--- Create a runnable group
---
---@param name string the name of the group to run
---@param fn func the function to run when the group is invoked
---
---@return nil 
---
function group(name, fn) end

---
--- Asserts the given boolean and raises an error if problematic
---
---@param value bool the condition to assert on
---@param brief string short explanation of the next step
---
---@return nil 
---
function assert(value, brief) end

---
--- Creates a backup of a file
---
---@param path string the file to create a backup of
---
---@return nil 
---
function Backup(path) end

---@class dict
---@field path string the file to insert the block into
---@field block string the multi-line text block to be inserted or updated
---@field insertafter? string the multi-line text block to be inserted or updated
---@field insertbefore? string the multi-line text block to be inserted or updated
---@field marker? string the multi-line text block to be inserted or updated
---@field markerbegin? string the multi-line text block to be inserted or updated
---@field markerend? string the multi-line text block to be inserted or updated
---@field state bool the multi-line text block to be inserted or updated
---@field backup? bool the multi-line text block to be inserted or updated
---@field create? bool the multi-line text block to be inserted or updated


---
--- Insert/update/remove a block of multi-line text surrounded by customizable markers in a file
---
---@param block_params dict the configuration for the block insertion
---
---@return nil 
---
function Blockinfile(block_params) end

---
--- Uppercase the first letter of a string
---
---@param txt string the text to capitalize
---
---@return string the text with capitalized first letter
---
function capitalize(txt) end

---@class dict
---@field source string the file or folder to copy
---@field dest string the destination to copy to
---@field strategy? string a strategy for how to manage conflicts (replace or merge, defaults to merge)
---@field symlink? string how to handle symlinks (deep/shallow/skip or the default skip)


---
--- Copies folder
---
---@param opts dict the copy options
---
---@return nil 
---
function Copy(opts) end

---
--- Installs Homebrew if not already installed
---
---
---@return nil 
---
function HomebrewInstall() end

---@class dict
---@field packages? array the homebrew packages to install
---@field taps? array the homebrew taps to install
---@field mas? array the homebrew mac app stores to install
---@field whalebrews? array the whalebrews install
---@field casks? array the homebrew casks to install


---
--- Marks a homebrew package for installation
---
---@param params dict the packages to install
---
---@return nil 
---
function Homebrew(params) end

---
--- Upgrades all homebrew packages
---
---
---@return nil 
---
function HomebrewUpgrade() end

---
--- Annotate the current group with some details
---
---@param brief string short explanation of the next step
---
---@return nil 
---
function note(brief) end

---
--- Print a string
---
---@param obj any the message or object to log
---
---@return nil 
---
function print(obj) end

---
--- Reads a file as a string
---
---@param path string the path of the file to read
---
---@return string the file content
---
function read(path) end

---
--- Run a shell command
---
---@param cmd string the shell command to run
---
---@return nil 
---
function Sh(cmd) end

---
--- Create a test case
---
---@param name string A description of the test
---@param fn func The test implementation
---
---@return nil 
---
function test(name, fn) end

---
--- Trims the extra indentation of a multi-line string
---
---@param txt string the text to trim
---
---@return string the trimmed text
---
function trim(txt) end

