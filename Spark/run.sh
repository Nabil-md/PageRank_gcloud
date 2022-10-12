#!/bin/bash

## En local ->
## spark -x local -

## en dataproc...

## copy data
gsutil cp small_page_links.nt gs://bucket_nabil_mhd/

## copy pig code
gsutil cp pagerank-notype.py gs://bucket_nabil_mhd/

## Clean out directory
gsutil rm -rf gs://bucket_nabil_mhd/out


## create the cluster
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project turnkey-brook-321909


## run
## (suppose that out directory is empty !!)
gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a gs://bucket_nabil_mhd/pagerank-notype.py  -- gs://myown_bucket/small_page_links.nt 3

## access results
gsutil cat gs://bucket_nabil_mhd/out/pagerank_data_1/part-r-00000

## delete cluster...
gcloud dataproc clusters delete cluster-a35a --region europe-west1

