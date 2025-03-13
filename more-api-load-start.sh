#!/bin/bash
docker run -d --rm --env-file ./chatgpt-load-gen/env.list chatgpt-load:v1.0
