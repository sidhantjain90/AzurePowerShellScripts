#Variables 
$SubscriptionID = "35170fc1-0426-4f0e-8577-b1c5202d8e90"
$TenantID="b6e77e52-65f6-4dec-b7d9-8e45f36a536f"
$ResourceGroupName = "RG-Sidhant"
$Location = "northeurope"
$VMName = "VM" + (Get-Random -Maximum 9999)
$SubnetName = "RG-Sidhant-Subnet"
$VNETName = "RG-Sidhant-vnet"
$NetworkInterface = "vm-powershellpractic426"

#Connect to Subscription
$CurrentContext = Get-AZcontext

if ( $CurrentContext )
{
    if ( $CurrentContext.Subscription.id -eq $SubscriptionID )
    {
        Write-Host "Connexion etablie a la subscription $($CurrentContext.Subscription.Name)"
    }
    else 
    {
        Set-AZcontext -Sunscription $SubscriptionID -ErrorAction Stop
        Write-Host "Connexion etablie. Selection de la subscription $($CurrentContext.Subscription.Name)"
    }
}
else 
{
    Write-Host "Aucune authentification Azure en cours. Connexion ..."
    $CurrentContext = Connect-AzAccount -Tenant $TenantID -Subscription $SubscriptionID -ErrorAction Stop
    Write-Host "Connexion etablie. Selection de la subscription $($CurrentContext.Subscription.Name)"

}

#Resource Group
$ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

if (-not ($ResourceGroup))
{
    $ResourceGroup = New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}


#Subnet
# $SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix 10.0.2.0/24 -WarningAction SilentlyContinue

$VNET = Get-AzVirtualNetwork -Name $VNETName

$SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNET -AddressPrefix "10.0.3.0/24" -WarningAction SilentlyContinue

$VNET | Set-AzVirtualNetwork

#VNET

if(-not $VNET)
{
    $VNET = New-AzVirtualNetwork -Name $VnetName -ResourceGroupName $RessourceGroupName -Location $Location -AddressPrefix 10.0.0.0/16 -Subnet $SubnetConfig -Confirm:$false

}

#NIC
$NIC = Get-AzNetworkInterface


#VM
