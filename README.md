# fluent-plugin-xsum

Here is an example of fluentd plugin as result of learning at [Fluentd Plugin development](https://docs.fluentd.org/plugin-development).

This plugin just do simple task for summing numbers, but the main purpose is teaching me how to write plugin for Fluentd.

This is a parser plugin to do summing numbers

Sample log:
```
2019-04-03T00:00:02 1,2,3,4,5,7,8,9
```

will be converted as:
```
2019-04-03T00:00:02+07:00	xsum.access	{"str":"1,2,3,4,5,7,8,9","sum":39}
```

## Installation
Assumed you already have fluentd installed on your machine. If not refer to [Fluentd Installation](https://docs.fluentd.org/installation/install-by-gem)
```
cd ~
git clone https://github.com:ugifractal/fluent-plugin-xsum.git
echo "source 'https://rubygems.org'" > SampleGemfile
```
## Sample configuration at /etc/fluent/fluent.conf
Append sample configuration

```
<source>
  @type tail
  path ~/any.log
  format none
  <parse>
    @type xsum 
  </parse>
  tag xsum.access
</source>

<match xsum.access>
  @type file
  path ~/xsumlog
</match>


```

## Running
```
echo "gem 'fluent-plugin-xsum', '0.1.0', path: '~/fluent-plugin-xsum'" >> SampleGemfile
fluentd --gemfile SampleGemfile
```

## Checking
```
echo "2019-04-03T00:00:02 1,2,3,4,5,7,8,9" >> ~/any.log 
ls ~/xsum*
```


## Copyright

* Copyright(c) 2019- sugiarto
* License
  * Apache License, Version 2.0
