resource "azurerm_virtual_network" "vnet_aula" {
    name                = "myVnet"
    address_space       = ["10.80.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_aula.name

    tags = {
        environment = "iac"
    }

    depends_on = [ azurerm_resource_group.rg_aula ]
}


resource "azurerm_public_ip" "publicip_aula_db" {
    name                         = "myPublicIPDB"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg_aula.name
    allocation_method            = "Static"
    idle_timeout_in_minutes = 30

    tags = {
        environment = "iac"
    }

    depends_on = [ azurerm_resource_group.rg_aula ]
}

resource "azurerm_subnet" "subnet_aula" {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.rg_aula.name
    virtual_network_name = azurerm_virtual_network.vnet_aula.name
    address_prefixes       = ["10.80.4.0/24"]

    depends_on = [ azurerm_resource_group.rg_aula]
}



resource "azurerm_network_interface" "nic_aula_db" {
    name                      = "myNICDB"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rg_aula.name

    ip_configuration {
        name                          = "myNicConfigurationDB"
 	subnet_id                     = azurerm_subnet.subnet_aula.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.80.4.10"
        public_ip_address_id          = azurerm_public_ip.publicip_aula_db.id
    }

    tags = {
        environment = "iac"
    }

    depends_on = [ azurerm_resource_group.rg_aula ]
}

resource "azurerm_network_interface_security_group_association" "nicsq_aula_db" {
    network_interface_id      = azurerm_network_interface.nic_aula_db.id
    network_security_group_id = azurerm_network_security_group.sg_aula.id

    depends_on = [ azurerm_network_interface.nic_aula_db, azurerm_network_security_group.sg_aula ]
}

resource "azurerm_network_security_group" "sg_aula" {
    name                = "myNetworkSecurityGroup"
    location            = var.location
    resource_group_name = azurerm_resource_group.rg_aula.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPInbound"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "HTTPOutbound"
        priority                   = 1003
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


  security_rule {
        name                       = "MySqlOutbound"
        priority                   = 1004
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


  security_rule {
        name                       = "MySqlInbound"
        priority                   = 1004
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3306"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "iac"
    }

    depends_on = [ azurerm_resource_group.rg_aula ]
}



data "azurerm_public_ip" "ip_aula_data_db" {
  name                = azurerm_public_ip.publicip_aula_db.name
  resource_group_name = azurerm_resource_group.rg_aula.name
}