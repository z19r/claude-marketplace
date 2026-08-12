---
title: "{{ replace .Name "-" " " | title }}"
name: "{{ .Name }}"
version: "0.1.0"
description: ""
author: "Zack Kitzmiller"
pluginPath: "plugins/{{ .Name }}"
keywords: []
category: "development"
date: {{ .Date }}
draft: false
---

Description and usage instructions.
