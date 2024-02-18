# Probably broken this thing

These files are doing weird things like `@<%= singular_table_name %>`, `<%= index_helper %>_path` and
`edit_<%= singular_table_name %>_path` in _form and index which I presume are some sort of runtime
variable resolution.  
Whatever it is Rubocop is not happy with it and I have no idea how to make it happy, so I'm editing the files to change
remove whatever those are.
This will probably brake something so this README is to alert anyone who encounters such errors.
