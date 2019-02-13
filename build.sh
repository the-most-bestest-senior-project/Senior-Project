#!/usr/bin/env bash
echo "*** Deployment started"

echo "***  starting terraform" 
sh terraform.sh; 
echo "*** Deployment complete"