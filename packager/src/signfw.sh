#!/bin/bash
codesign --sign $1 --force --all --option=library $2
