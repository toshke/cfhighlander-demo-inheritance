## Intro

This is training / demo repository for [cfhighlander](https://github.com/theonestack/cfhighlander)
inheritance capabilities. Cfhighlander as infrastructure coding tool makes use of well known 
development patterns of object oriented programming, and tries to apply them to infrastructure
coding. Templates, as first class citizens in cfhighlander world, can inherit behaviour 
of other templates. 

## Try it yourself

```
## make sure to uninstall all previous versions if you have any, 
## so the proper code is returned from gem cache
$ git clone https://github.com/toshke/cfhighlander && cd cfhighlander && git checkout feature/extend
$ gem build cfhighlander.gemspec && gem install cfhighlander-*.gem && cd ..
$ git clone https://github.com/toshke/cfhighlander-inheritance-demo
$ cd cfhighlander-inheritance-demo
$ cfhighlander cfcompile master
```

## Details
 
Everything except for template name, version and description is being inherited from  parent
template by child template. Dsl Statement for inheritance is simple `Extends` , borrowed from
Java. 

### Cfndsl templates

Cfndsl content of child template is appended to parent template. This way, child can shadow resources
defined in parent by giving them same name


### Component configuration

Any configuration key values defined by parent template can be overwritten in child template.

### Highlander Statements

Highlander statements (parameters, lambda functions, subcomponents) are all inherited from parent.
In-memory model effectively creates single instance of `CfhighlanderTemplate` object model, and applies 
all DSL statements (meaning both from parent and child templates) to this instance. 
 
First, parent DSL methods are applied
 
Secondly, child DSL methods are applied. You can shadow parent definitions here, or extend capabilities
by adding new definitions. 

## Example details

This repo defines 3-level hierarchy, where `master` extends `child` template, which further extends `parent`
template. `child` and `master` are defined within root directory, whereas `parent` has it's own directory. 

#### Example of shadowing highlander definition

`child` template shadows parents definition of `parentParamToBeOverwritten` by chaging it's type from 
 `String` to `AWS::EC2::Subnet::Id`.
 



#### Example of extending highlander definitions

In example presented, 

`master`  defines `masterParameterShouldBeSiblingToParentAndChild`, 

`child` defines `childParamToBeUsed` and overwrites `parentParamToBeOverwritten` from `parent`, 

`parent` defines `parentParamToBeOverwritten` and `parentParamToBeUsed`

Resulting cloudformation contains all 4 stack parameters


contents of `out/yaml/master.compiled.yaml`
```yaml
 parentParamToBeUsed:
    Type: String
    Default: ''
    NoEcho: false
  parentParamToBeOverwritten:
    Type: AWS::EC2::Subnet::Id
    Default: ''
    NoEcho: false
  childParamToBeUsed:
    Type: String
    Default: ''
    NoEcho: false
  masterParameterShouldBeSiblingToParentAndChild:
    Type: String
    Default: ''
    NoEcho: false
```



#### Example of shadowing [cfndsl](https://github.com/cfndsl/cfndsl) resource definitions.

`child` template redefines ec2 instance resource named `applicationInstance` with new Amazon Machine Image (AMI),
and added instance type information coming from component configuration file. (This is just an example,
always place your instances in ASGs, even single instance, to achieve high availability in case of instance 
failure).

Resulting cloudformation template uses definitions from `child` template:

```yaml
---
AWSTemplateFormatVersion: '2010-09-09'
Resources:
.....
# defined in child template, shadowing parent template definition
  applicationInstance:
    Properties:
      ImageId: ami-7105540e    
      InstanceType: m5.medium
      
....
```



#### Example of extending [cfndsl](https://github.com/cfndsl/cfndsl) templates.

Each highlander template in hierarchy defines one or more s3 buckets. If you look at 
compiled cloudoformation template in `out/yaml/master.compiled.yaml`, there are following buckets

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  parentDefinedBucket:
    Type: AWS::S3::Bucket
  iExistWithCondition2:
    Type: AWS::S3::Bucket
  childDefinedBucket:
    Type: AWS::S3::Bucket
  masterDefinedBucket:
    Type: AWS::S3::Bucket
```

`parentDefinedBucket`, `childDefinedBucket` and `masterDefinedBucket` are all coming from different templates
in hierarchy, but result in them being rendered within same CloudFormation template. 



#### Example of shadowing configuration settings

Parent template defines conditional buckets `iExistWithCondition` and `iExistWithCondition2`, dependant on 
configuration keys `conditinalbucket` (true in parent config) and `conditinalbucket2` (false in parent config).

This configuration values are changed in hierarchy, so:

 - Child templates disables `conditionalbucket`
 - Master template enables  `conditinalbucket2`
 
Result - 2 levels up (or down) in hierarchy, AWS resource that will get rendered and created in parent, 
won't exist in child, and vice versa. 



#### Example of extending configuration settings

`child` template, extended by master, adds `child_key: child` configuration value.
Once component is compiled into resulting cloudformation template, intermediate configuration for master component
in `out/config/master.config.yaml` includes this configuration key.


```yaml
---
# defined in parent, overwritten in child
parent_key: overwritten_in_child

# defined in parent, and inherited in child and subsequently in master
parent_standolone_key: this should not be overwritten
conditionalbucket: false
conditionalbucket2: true
component_version: latest
component_name: master
template_name: master
template_version: latest

# child key, defined in child, and inherited by 
child_key: child
application_instance_type: m5.medium

# master template only defined configuration setting
master_only: hello, world!
description: master@latest - vlatest

```