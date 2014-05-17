# Atlassian Confluence on OpenShift

This OpenShift Quickstart will help you deploy [Atlassian Confluence](https://www.atlassian.com/software/confluence).

## Current version: 5.5

The Tomcat 7 engine included with the standalone install base is used, along with a PostgreSQL 9.2 database cartridge, which is automatically configured as a JDBC datasource. You will need to specify the datasource name during setup (see below).

**Gear Warning:** The small gear size (RAM and disk-space) is insufficient. You will need a gear with 700MB+ of RAM and 10GB+ of disk storage to accommodate the resource requirements of Confluence and PostgreSQL.


## Deployment Guide

This Quickstart downloads the Confluence standalone installation file from Atlassian, so their TOS applies to any such code in the gear's dependency folder. To begin deployment you may use the following command from an RHC configured terminal:

    rhc app create confluence diy-0.1 postgresql-9.2 --from-code=https://github.com/org-binbab/openshift-confluence.git

When asked by the Confluence Setup Wizard to configure the database, follow these steps:

  1. Use an **External** database
  2. Database type of **PostgreSQL**
  3. Use a pre-configured **datasource**
  4. The **datasource path** is `java:comp/env/jdbc/confluence`

**The database configuration will likely stall with a proxy error.**

Wait several minutes and then change the url in your browser to `/setup` to continue the setup process.

### Upgrading

By pushing an updated version of this repository (with a different Confluence version number), your deployment
will be ungraded automatically, and all data and settings should be preserved. A full backup is recommended, and you
are responsible for any data loss incurred.

You should carefully read any release notes provided by the vendor between your old version and your new version.

### Changing the deployed version number

The version of Confluence deployed is governed by the `confluence/version` file in this repository.

## Authors and License

  * Author:: BinaryBabel OSS (<projects@binarybabel.org>)
  * Copyright:: 2013 `sha1(OWNER) = df334a7237f10846a0ca302bd323e35ee1463931`
  * License:: GNU General Public License

----

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
