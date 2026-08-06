
# SAOImageDS9 self hosted flatpak build 

After downloading the final artifact, extract and sign every unique commit on your trusted host:


```
export GPG_KEY_ID=ABC1234567890XYZ
bash final_package.sh
```

Then generate the public key, .flatpakrepo, and final distribution tar as previously discussed.
