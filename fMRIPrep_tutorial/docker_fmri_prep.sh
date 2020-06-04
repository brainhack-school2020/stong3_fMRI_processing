docker run -it --rm \
    -v /Users/stong3/Desktop/test_fmriprep_PAD/sourcedata:/data:ro \
    -v /Users/stong3/Desktop/test_fmriprep_PAD/derivative:/out \
    -v /Users/stong3/Desktop/test_fmriprep_PAD/fs_license/license.txt:/opt/freesurfer/license.txt \
    -v /Users/stong3/Desktop/test_fmriprep_PAD/work_dir:/work \
    poldracklab/fmriprep:latest \
    /data /out/fmriprep \
    participant \
    --participant-label sub-00001 \
    -w /work \
    --low-mem \
    --output-spaces T1w \
    --write-graph \
    --fs-license-file /opt/freesurfer/license.txt