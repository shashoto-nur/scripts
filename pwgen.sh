#!/bin/bash
LENGTH=12
tr -dc A-Za-z0-9 < /dev/urandom | head -c $LENGTH | xargs
