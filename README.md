# Sports Betting Analyst & Odds Intelligence (Factory Droid)

Workspace và bộ chỉ dẫn chiến lược dành riêng cho **Factory Droid** để phân tích dữ liệu thể thao, bóc tách odds, nhận diện bẫy nhà cái và tư vấn kèo cược / kèo xiên bảo toàn vốn.

## Cấu trúc cốt lõi
- **`AGENTS.md`**: File chỉ dẫn cốt lõi (Core Instructions) định hình vai trò, tư duy xác suất, quy tắc chống ảo giác (Anti-Hallucination), quy tắc phòng ngừa bẫy odds (Anti-Trap Odds), nguyên tắc chủ động bỏ qua trận rủi ro (Proactive Skip Rule) và cấu trúc bảng xếp hạng cược xiên (Parlay Ranking).
- **Scripts OCR (`*.ps1`)**: Các tiện ích PowerShell sử dụng Windows Runtime OCR API tích hợp sẵn trong Windows 10/11 để tự động nhận diện và trích xuất bảng kèo, mốc cược, tỷ lệ odds trực tiếp từ ảnh chụp màn hình độ nét cao.

## Cách sử dụng trên Laptop
1. Clone repo này về máy tính laptop:
   ```bash
   git clone <URL_REPO_GITHUB> "sporting analyze"
   ```
2. Mở thư mục này trong Factory (Droid):
   - Droid sẽ tự động nạp toàn bộ cấu hình, tư duy và quy tắc từ `AGENTS.md`.
   - Mọi phân tích soi kèo, thẩm định vé xiên và trích xuất ảnh sẽ được áp dụng theo đúng phong cách chuyên gia sắc bén, bảo toàn vốn như trên PC.
