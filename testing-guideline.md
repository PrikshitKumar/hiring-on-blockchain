# **Testing Guidelines for Hiring on Blockchain**

## **1. Clone the Repository**  
Open your terminal and run:  
```sh
git clone https://github.com/PrikshitKumar/hiring-on-blockchain.git
cd hiring-on-blockchain
```

## **2. Install Foundry (If Not Installed)**  
Foundry is required to compile, test, and debug the smart contracts.  

- Follow the official Foundry installation guide: [Foundry Installation](https://book.getfoundry.sh/getting-started/installation)
- Or install directly via script:  
  ```sh
  curl -L https://foundry.paradigm.xyz | bash
  foundryup
  ```

## **3. Compile Smart Contracts**  
Before running tests, ensure your contracts compile successfully:  
```sh
forge clean  
forge build  
```

## **4. Run Tests**  
Execute all test cases with verbose output:  
```sh
forge test -vv  
```
- `-vv` increases verbosity, showing logs and assertions.  
- For even more detailed output, use `-vvv` (shows stack traces).  

### **Note:**  
- Reset your environment with `forge clean` if you encounter build issues.  
