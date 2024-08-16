import React, { useState } from 'react';
import { ethers } from 'ethers';
import liangTokenABI from '../abi/liangtoken.json'; // Adjust the path to your ABI

const BorrowPage: React.FC = () => {
  const [amount, setAmount] = useState<number | string>('');
  const [isConnected, setIsConnected] = useState<boolean>(false);

  const handleAmountChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setAmount(e.target.value);
  };

  const connectWallet = async () => {
    if (!window.ethereum) {
      alert('MetaMask is required to use this application.');
      return;
    }

    try {
      await window.ethereum.request({ method: 'eth_requestAccounts' });
      setIsConnected(true);
    } catch (error) {
      console.error('User denied account access', error);
    }
  };

  const handleSubmit = async () => {
    if (!window.ethereum) {
      alert('MetaMask is required to use this application.');
      return;
    }

    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();

      const contractAddress = '0xYourContractAddress'; // Replace with your actual contract address
      const contract = new ethers.Contract(contractAddress, liangTokenABI, signer);

      const transaction = await contract.borrowFunds(ethers.utils.parseEther(amount.toString()));
      await transaction.wait();
      alert('Funds borrowed successfully!');
    } catch (error) {
      console.error('Error borrowing funds:', error);
      alert('Error borrowing funds. Please try again.');
    }
  };

  return (
    <div className="flex flex-col min-h-screen bg-gray-50">
      <header className="bg-blue-600 text-white p-6 shadow-lg">
        <div className="container mx-auto flex justify-between items-center">
          <h1 className="text-3xl font-bold">CryptoLend</h1>
          <button
            onClick={connectWallet}
            className={`bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 transition ${isConnected ? 'hidden' : 'block'}`}
          >
            Connect Wallet
          </button>
        </div>
      </header>

      <main className="flex flex-col items-center justify-center flex-1 p-6">
        <div className="bg-white shadow-lg rounded-lg p-8 w-full max-w-md border border-gray-200">
          <h2 className="text-2xl font-semibold mb-6 text-gray-700">Borrow Funds</h2>
          <input
            type="number"
            value={amount}
            onChange={handleAmountChange}
            placeholder="Enter amount to borrow"
            className="w-full p-4 border border-gray-300 rounded-lg mb-4 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
          />
          <button
            onClick={handleSubmit}
            className={`w-full bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition ${!isConnected ? 'opacity-50 cursor-not-allowed' : ''}`}
            disabled={!isConnected}
          >
            Submit
          </button>
        </div>
      </main>

      <footer className="bg-blue-600 text-white p-4 text-center">
        <p>&copy; 2024 CryptoLend</p>
      </footer>
    </div>
  );
};

export default BorrowPage;
