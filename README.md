
# Aptos-Counter

## Giới thiệu
**Aptos-Counter** là một dự án mẫu sử dụng ngôn ngữ Move trên nền tảng Aptos. Dự án này triển khai module `publisher::counter`, quản lý một biến đếm đơn giản cho từng tài khoản. Người dùng có thể tăng giá trị của biến đếm (sử dụng hàm `bump`) và truy vấn giá trị hiện tại (sử dụng hàm `get_count`).

## Tính năng
- **Tăng biến đếm**: Gọi hàm `bump` để tăng giá trị biến đếm. Nếu tài khoản chưa có đối tượng `CounterHolder`, hệ thống sẽ tự động tạo mới với giá trị ban đầu là 0.
- **Truy vấn biến đếm**: Sử dụng hàm `get_count` để xem giá trị biến đếm hiện tại của một địa chỉ tài khoản.

## Yêu cầu
- **Aptos CLI**: Đảm bảo bạn đã cài đặt Aptos CLI ([Hướng dẫn cài đặt](https://aptos.dev/cli-tools/aptos-cli/)).
- **Move Language**: Có môi trường để biên dịch và triển khai các module Move.
- **Tài khoản Aptos**: Cần có địa chỉ tài khoản Aptos để triển khai module.

## Cài đặt và Triển khai

1. **Clone Repository:**
   ```sh
   git clone https://github.com/cong9362/Aptos-Counter.git
   cd Aptos-Counter
   
2.  **Biên dịch Module:** Biên dịch module với Aptos CLI (đảm bảo thay `publisher=0xYourAddress` bằng địa chỉ của bạn):
    
    sh
    
    CopyEdit
    
    `aptos move compile --named-addresses publisher=0xYourAddress` 
    
3.  **Triển khai Module:** Triển khai module lên mạng Aptos:
    
    sh
    
    CopyEdit
    
    `aptos move publish --named-addresses publisher=0xYourAddress` 
    

## Hướng dẫn Sử dụng

-   **Tăng biến đếm (bump):**
    -   Gọi hàm `bump` từ tài khoản của bạn. Nếu tài khoản chưa có `CounterHolder`, module sẽ tạo mới với giá trị ban đầu là 0; nếu đã có, giá trị sẽ được tăng lên 1.
-   **Truy vấn biến đếm (get_count):**
    -   Sử dụng hàm `get_count` để lấy giá trị biến đếm hiện tại từ địa chỉ của tài khoản.
    -   Ví dụ:
        
        move
        
        CopyEdit
        
        `let count = publisher::counter::get_count(your_account_address);` 
        

## Code Ví Dụ

move

CopyEdit

`module publisher::counter {

    use std::signer;

    struct CounterHolder has key {
        count : u64
    }

    #[view]
    public fun get_count(addr: address): u64 acquires CounterHolder {
        // Kiểm tra sự tồn tại của CounterHolder trên địa chỉ được cung cấp
        assert!(exists<CounterHolder>(addr), 0);
        *&borrow_global<CounterHolder>(addr).count
    }

    public entry fun bump(account: signer) acquires CounterHolder {
        let addr = signer::address_of(&account);
        if (!exists<CounterHolder>(addr)) {
            // Nếu chưa tồn tại CounterHolder, khởi tạo mới với giá trị 0
            move_to(&account, CounterHolder { count: 0 })
        } else {
            // Nếu đã tồn tại, tăng giá trị biến đếm lên 1
            let old_count = borrow_global_mut<CounterHolder>(addr);
            old_count.count = old_count.count + 1;
        }
    }
}` 

## Lưu ý

-   Hàm `bump` yêu cầu một signer làm tham số, đảm bảo rằng giao dịch được xác thực.
-   Hàm `get_count` được đánh dấu là `[view]` nên có thể được gọi mà không tốn phí giao dịch.
-   Nếu `CounterHolder` chưa được khởi tạo cho một địa chỉ, hàm `bump` sẽ tự động tạo mới.

## Đóng góp

Nếu bạn muốn đóng góp cho dự án:

1.  Fork repository.
2.  Tạo branch mới cho tính năng hoặc sửa lỗi (`feature/your-feature`).
3.  Commit và push thay đổi.
4.  Gửi Pull Request để xem xét.
