knife-inventory
===============

A Chef Knife Plugin to Inventory your environment and output to CSV


## Place the files

Copy these files to the plugin directory of your chef installation.

You could also symlink the files in this repo, or simply specify this repo as a place to look for plugins in your knife configuration

## Usage

`knife inventory`
`knife inventory html`

Results will print to STDOUT, use ridirection to output to file or generate an email, for example...

`knife inventory > ~/chef/inventory/$(date +%Y-%m-%d).csv`

or

`knife inventory | mail -s "Chef Inventory Report for $(date +%Y-%m-%d)" user@example.com`
