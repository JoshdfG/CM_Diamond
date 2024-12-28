const { getSelectors, FacetCutAction } = require("./libraries/diamond.js");
const { ethers } = require("hardhat");
const fs = require("fs");

async function deployDiamond() {
  const accounts = await ethers.getSigners();
  // const contractOwner = accounts[0];
  const contractOwner = new ethers.Wallet(process.env.PRIVATE_KEY).address;
  const address_zero = "0x0000000000000000000000000000000000000000";

  // deploy DiamondInit
  // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
  // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2535#addingreplacingremoving-functions
  const DiamondInit = await ethers.getContractFactory("DiamondInit");
  const diamondInit = await DiamondInit.deploy();
  await diamondInit.deployed();
  console.log("DiamondInit deployed:", diamondInit.address);

  // deploy facets
  console.log("");
  console.log("Deploying facets");
  const FacetNames = [
    "DiamondCutFacet",
    "DiamondLoupeFacet",
    "OwnershipFacet",
  ];
  const cut = [];
  for (const FacetName of FacetNames) {
    const Facet = await ethers.getContractFactory(FacetName);
    const facet = await Facet.deploy();
    await facet.deployed();
    console.log(`${FacetName} deployed: ${facet.address}`);
    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Add,
      functionSelectors: getSelectors(facet),
    });
  }

  // deploy LibOrganisation
  const LibOrganisation = await ethers.getContractFactory("LibOrganisation");
  const libOrganisation = await LibOrganisation.deploy();
  console.log("LibOrganisation deployed:", libOrganisation.address);

  // deploy OrganisationFactoryFacet
  const OrganisationFactoryFacet = await ethers.getContractFactory(
    "OrganisationFactoryFacet", {
      libraries: {
        LibOrganisation: libOrganisation.address,
      },
    }
  );
  const organisationFactoryFacet = await OrganisationFactoryFacet.deploy();
  await organisationFactoryFacet.deployed();
  console.log(
    "OrganisationFactoryFacet deployed:",
    organisationFactoryFacet.address
  );

  cut.push({
    facetAddress: organisationFactoryFacet.address,
    action: FacetCutAction.Add,
    functionSelectors: getSelectors(organisationFactoryFacet),
  });

  // deploy Diamond
  const Diamond = await ethers.getContractFactory("Diamond");
  const diamond = await Diamond.deploy(
    contractOwner.address,
    cut,
    address_zero,
    ""
  );
  await diamond.deployed();
  console.log("Diamond deployed:", diamond.address);

  // // upgrade diamond with facets
  // console.log("");
  // console.log("Diamond Cut:", cut);
  // const diamondCut = await ethers.getContractAt("IDiamondCut", diamond.address);
  // let tx;
  // let receipt;
  // // call to init function
  // let functionCall = diamondInit.interface.encodeFunctionData("init");
  // tx = await diamondCut.diamondCut(cut, diamondInit.address, functionCall);
  // console.log("Diamond cut tx: ", tx.hash);
  // receipt = await tx.wait();
  // if (!receipt.status) {
  //   throw Error(`Diamond upgrade failed: ${tx.hash}`);
  // }
  // console.log("Completed diamond cut");

  fs.writeFileSync(`scripts/interractions/data.json`, JSON.stringify(daoData));

  return diamond.address;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
if (require.main === module) {
  deployDiamond()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
}

exports.deployDiamond = deployDiamond;
